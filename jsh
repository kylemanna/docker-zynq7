#!/bin/bash
#
# Wrapper to fix issues with ssh when the uid isn't in /etc/passwd
#
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/tmp/group
echo "build:x:${USER_ID:-121}:${GROUP_ID:-134}::${WORKDIR:-/zynq7}:/bin/bash" > $NSS_WRAPPER_PASSWD
echo "build:x:${GROUP_ID:-134}:" > $NSS_WRAPPER_GROUP
export LD_PRELOAD=libnss_wrapper.so
exec $@
