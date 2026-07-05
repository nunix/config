# Imperium Armory — Containers

Anonymized Containerfiles and Podman Quadlet units from the Nunix Universe Imperium fleet (`fleet-v3` command center + `nunix-blog` Docusaurus site). Hostnames, credentials, and local paths are replaced with `[PLACEHOLDER]` tokens — swap them for your own before use.

| File | Purpose |
|---|---|
| `fleet-v3.Containerfile` | Multi-stage build (frontend-dev, backend-dev, prod) for the Go + Vite command center |
| `nunix-blog.Containerfile` | Bun-based multi-stage build (dev, build, prod) for the Docusaurus blog |
| `fleet-v3.container` | Podman Quadlet unit — command center prod service |
| `nunix-blog-dev.container` | Podman Quadlet unit — blog dev/hot-reload service |
| `nunix-blog.container` | Podman Quadlet unit — blog prod service |

Full writeup and gist links: [The Armory](https://nunix.dev/aiverse/armory/armory-index) on the AIverse chronicle.
