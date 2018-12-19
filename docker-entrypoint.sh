#!/bin/bash
set -e

# This script designed to be used a docker ENTRYPOINT "workaround" missing docker
# feature discussed in docker/docker#7198, allow to have executable in the docker
# container manipulating files in the shared volume owned by the BUILD_UID:BUILD_GID.
#
# It creates a user named `build` with selected BUILD_UID and BUILD_GID (or
# 1000 if not specified).

# Example:
#
#  docker run -ti -e BUILD_UID=$(id -u) -e BUILD_GID=$(id -g) imagename bash
#

dbg_echo() {
    if [ -n "${DEBUG+x}" ]; then
        echo $@
    fi
}

# Optimal MAKEFLAGS argument if not already defined
if [ -z ${MAKEFLAGS+x} ]; then
    # Add 1 assuming disk IO will block processes from time to time.
    export MAKEFLAGS=-j$((1 + $(grep processor /proc/cpuinfo | wc -l)))
fi

args="$@"
# Default to 'bash' if no arguments are provided
if [ -z "$args" ]; then
    args="bash"
fi

# Jenkins runs as a user that can't create users, just run the command
if [ -n "${JENKINS_URL}" ]; then
    exec "$@"
fi

# Reasonable defaults if no BUILD_UID/BUILD_GID environment variables are set.
BUILD_UID=${BUILD_UID:-$(stat -c %u /zynq7)}
BUILD_GID=${BUILD_GID:-$(stat -c %g /zynq7)}
msg="docker_entrypoint: Creating user UID/GID [$BUILD_UID/$BUILD_GID]" && dbg_echo $msg
groupadd -g $BUILD_GID -r build && \
useradd -u $BUILD_UID -d "$WORKDIR" -r -g build build
dbg_echo "$msg - done"

dbg_echo ""

# Execute command as `build` user
export HOME="$WORKDIR"
exec gosu build $args
