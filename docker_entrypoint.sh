#!/bin/bash
set -e

# This script designed to be used a docker ENTRYPOINT "workaround" missing docker
# feature discussed in docker/docker#7198, allow to have executable in the docker
# container manipulating files in the shared volume owned by the USER_ID:GROUP_ID.
#
# It creates a user named `build` with selected USER_ID and GROUP_ID (or
# 1000 if not specified).

# Example:
#
#  docker run -ti -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) imagename bash
#

dbg_echo() {
    if [ -n "${DEBUG+x}" ]; then
        echo $@
    fi
}

# Reasonable defaults if no USER_ID/GROUP_ID environment variables are set.
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi
msg="docker_entrypoint: Creating user UID/GID [$USER_ID/$GROUP_ID]" && dbg_echo $msg
groupadd -g $GROUP_ID -r build && \
useradd -u $USER_ID --create-home -r -g build build
dbg_echo "$msg - done"

dbg_echo ""

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="bash"
fi

# Optimal MAKEFLAGS argument if not already defined
if [ -z ${MAKEFLAGS+x} ]; then
    # Add 1 assuming disk IO will block processes from time to time.
    export MAKEFLAGS=$((1 + $(grep processor /proc/cpuinfo | wc -l)))
fi

# Execute command as `build` user
export HOME=/home/build
exec sudo -E -u build $args
