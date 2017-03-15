#
# Toolchain for building Yocto for Xilinx Zynq 7000 Series SOCs + FPGAs
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna>

RUN apt-get update && \
    apt-get install -y \
                       build-essential \
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
                       python3-pip \
                       python3-pexpect \
                       socat \
                       texinfo \
                       unzip \
                       wget \
                       && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /build
WORKDIR /build

ENV USE_CCACHE 1
ENV CCACHE_DIR /build/.ccache

COPY docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
