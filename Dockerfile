FROM ubuntu:16.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ARG PYTHON_VERSIONS="3.6.4 3.5.4 3.4.7 pypy3.5-5.10.0 2.7.14 pypy2.7-5.10.0"

ENV PYENV_VERSION_TAG="v1.2.1" \
    PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:/opt/pyenv/shims:$PATH"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libbz2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone -b $PYENV_VERSION_TAG --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && for version in $PYTHON_VERSIONS; do pyenv install $version; done \
 && pyenv global $PYTHON_VERSIONS

VOLUME /src
WORKDIR /src
