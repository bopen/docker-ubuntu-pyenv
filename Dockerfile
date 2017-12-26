FROM ubuntu:16.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ENV PYENV_VERSION_TAG="v1.2.0" \
    PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:/opt/pyenv/shims:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    libbz2-dev \
    libncurses5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    wget \
    xz-utils \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone -b $PYENV_VERSION_TAG --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT

COPY python-versions.txt /

RUN xargs -P 4 -n 1 pyenv install < /python-versions.txt \
    && pyenv global $(cat /python-versions.txt)

VOLUME /src
