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

RUN mkdir /build
WORKDIR /build

ENV USE_CCACHE 1
ENV CCACHE_DIR /build/.ccache

# https://github.com/docker-library/python/blob/11c0afba4b7b28bc671ec92ec16c0b04380dbc05/3.6/Dockerfile
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

COPY docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
