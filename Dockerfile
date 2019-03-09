#
# Toolchain for building Yocto for Xilinx Zynq 7000 Series SOCs + FPGAs
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt update && \
    apt install -y --no-install-recommends \
                       apt-transport-https \
                       build-essential \
                       ccache \
                       chrpath \
                       cpio \
                       diffstat \
                       dvipng \
                       file \
                       gawk \
                       gcc-multilib \
                       git-core \
                       gosu \
                       iputils-ping \
                       latexmk\
                       libgtk2.0-0 \
                       libnss-wrapper \
                       libsdl1.2-dev \
                       locales \
                       openssh-client \
                       python \
                       python-pexpect \
                       python3 \
                       python3-pexpect \
                       python3-pip \
                       python3-requests \
                       repo \
                       rsync \
                       socat \
                       texinfo \
                       texlive-fonts-recommended \
                       texlive-latex-extra \
                       unzip \
                       wget \
                       x11-utils \
                       xvfb \
                       && \
    wget -qO - https://packagecloud.io/github/git-lfs/gpgkey | apt-key add - && \
    echo 'deb https://packagecloud.io/github/git-lfs/ubuntu/ trusty main' | tee /etc/apt/sources.list.d/github_git-lfs.list && \
    apt update && \
    apt install -y git-lfs && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    python3 -m pip install --upgrade --no-cache-dir pip && \
    python3 -m pip install --no-cache-dir setuptools unittest-xml-reporting

ENV LANG=en_US.UTF-8 \
    WORKDIR=/zynq7 \
    CCACHE_DIR=/zynq7/.ccache \
    USE_CCACHE=1 \
    SSH_AUTH_SOCK=/tmp/ssh-agent.sock \
    XZ_DEFAULTS="--threads 0"


# https://github.com/docker-library/python/blob/11c0afba4b7b28bc671ec92ec16c0b04380dbc05/3.6/Dockerfile
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
RUN locale-gen $LANG; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN mkdir "$WORKDIR" && chmod 777 "$WORKDIR" && chown 1000:1000 "$WORKDIR"
RUN mkdir "/var/lib/jenkins" && chmod 777 "/var/lib/jenkins"
WORKDIR $WORKDIR

COPY docker-entrypoint.sh nssh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
