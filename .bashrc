# Set the line separator
## Hint: useful for not breaking variables in FOR loops
IFS=$'\n'

# Distrobox Host
if [ -z $CONTAINER_ID ]
then
        source $HOME/.bash_alias
        function dapps {
                # USER header
                printf "USER\n========\n\n"

                # Get all dbox from user
                dboxList=`distrobox list`
                for box in `echo "$dboxList" | grep -v NAME | awk '{ print $3 }'`
                do
                        # dbox header
                        printf "📦  [ $box ]\n"
                        echo "---------------------"

                        # Get box current status
                        dboxStatus=`podman inspect ${box} --format '{{ .State.Status }}'`

                        # Start the container if it's not running
                        if [ ! "$dboxStatus" == "running" ]
                        then
                                podman start ${box} &> /dev/null
                                wait $!
                        fi

                        # Get all applications running in dbox
                        dboxApps=`distrobox enter ${box} -- distrobox-export --list-apps | awk -F"|" '{ print $1 }'`
                        for app in `printf "$dboxApps"`
                        do
                                printf "🖥\t${app}\n"
                        done

                        # Get all binaries running in dbox
                        for bin in `distrobox enter ${box} -- distrobox-export --list-binaries`
                        do
                                printf "📄\t${bin}\n"
                        done

                        # Stops the container is the status was not running
                        if [ ! "$dboxStatus" == "running" ]
                        then
                                distrobox stop ${box} &> /dev/null
                        fi

                        echo
                done
        }
        alias dlist="printf \"USER\n========\n\" && distrobox list && echo && printf \"ROOT\n========\n\" && distrobox list --root"

        # Refresh the alias list
        function dbox { distrobox "$@" && source $HOME/.bash_alias; }

# Distrobox Instances
else
        # Updates path in "init" instances
        if [ `ps -fp 1 -o user=` == "root" ]
        then
                export PATH="$HOME/.local/bin:$PATH"
        fi
        alias hodo="distrobox-host-exec"
        alias dexa="distrobox-export -a"
        alias dexb="distrobox-export -b"
fi

# Rust
. "$HOME/.cargo/env"

# Yarn + Node
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Starship
eval "$(starship init bash)"

# Random number
function swisschoco { echo $((1 + $RANDOM % $1)); }
