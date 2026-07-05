# =========================================================================
# fleet-v3 command center — multi-stage Containerfile
# Targets: frontend-dev (frontend hot reload), backend-dev (go run hot reload),
#          prod (default — embeds built frontend into Go binary via go:embed)
# =========================================================================

# --- Frontend deps (shared by dev + build) ---------------------------------
FROM registry.suse.com/bci/nodejs:20 AS frontend-base
WORKDIR /app
COPY frontend/package*.json ./
# --legacy-peer-deps: repo has an eslint-plugin-import@2.32 vs eslint@10.4
# peer-dep mismatch (devDependencies only, pre-existing in package.json,
# not introduced here). Standard npm flag, not a workaround script.
RUN npm install --legacy-peer-deps

# --- Frontend DEV target: hot reload against bind-mounted source -----------
# Run with source bind-mounted at /app (do NOT bake source into image).
# Example: podman run -v ./frontend:/app:Z -p 5174:5174 --target frontend-dev
FROM frontend-base AS frontend-dev
EXPOSE 5174
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5174"]

# --- Frontend BUILD stage (prod path) ---------------------------------------
FROM frontend-base AS frontend-build
COPY frontend/ ./
RUN npm run build
# vite.config.js build.outDir = '../backend/dist' -> resolves to /backend/dist
# in this stage's filesystem (WORKDIR is /app, sibling to /backend). This is
# intentional, verified working — do not "fix" this path.

# --- Backend DEV target: go run against bind-mounted source, no image bake --
# go.mod requires go 1.25.9 -> golang:1.25 satisfies it (verified pullable
# from registry.suse.com).
FROM registry.suse.com/bci/golang:1.25 AS backend-dev
WORKDIR /app
EXPOSE 5173
CMD ["go", "run", "."]

# --- Backend BUILD stage (prod path) ----------------------------------------
FROM registry.suse.com/bci/golang:1.25 AS backend-build
WORKDIR /app
COPY backend/go.mod backend/go.sum ./
RUN go mod download
COPY backend/ ./
COPY --from=frontend-build /app/../backend/dist ./dist
RUN go build -o fleet-v3 .

# --- PROD runtime — SLE Micro minimal (default final target) ---------------
FROM registry.suse.com/bci/bci-micro:latest AS prod
WORKDIR /app
COPY --from=backend-build /app/fleet-v3 .
EXPOSE 5173
CMD ["./fleet-v3"]
