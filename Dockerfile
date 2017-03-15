#
# Toolchain for building Yocto for Xilinx Zynq 7000 Series SOCs + FPGAs
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna>

RUN apt-get update && \
    apt-get install -y \
                       build-essential \
                       ccache \
                       chrpath \
                       cpio \
                       diffstat \
                       gawk \
                       gcc-multilib \
                       git-core \
                       libsdl1.2-dev \
                       python \
                       python-pexpect \
                       python3 \
                       python3-pexpect \
                       python3-pip \
                       repo \
                       socat \
                       sudo \
                       texinfo \
                       unzip \
                       wget \
                       && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=en_US.UTF-8 \
    WORKDIR=/zynq7 \
    CCACHE_DIR=/build/.ccache \
    USE_CCACHE=1

# https://github.com/docker-library/python/blob/11c0afba4b7b28bc671ec92ec16c0b04380dbc05/3.6/Dockerfile
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
RUN locale-gen $LANG; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN mkdir "$WORKDIR" && chmod 777 "$WORKDIR" && chown 1000:1000 "$WORKDIR"
WORKDIR $WORKDIR

COPY docker-entrypoint.sh /root/docker-entrypoint.sh
ENTRYPOINT ["/root/docker-entrypoint.sh"]
