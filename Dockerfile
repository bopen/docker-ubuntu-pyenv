FROM ubuntu:16.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ARG PYENV_VERSION_TAG="v1.2.1"
ARG PYTHON_VERSIONS="3.6.4 3.5.4 3.4.7 pypy3.5-5.10.0 2.7.14 pypy2.7-5.10.0"
ARG DEBIAN_FRONTEND=noninteractive
ARG COMMON_SETUP_DEPENDENCIES="cython==0.27.3 numpy==1.14.0 pytest-runner==3.0"
ARG COMMON_TEST_DEPENDENCIES="detox==0.11 tox==2.9.1 tox-pyenv==1.1.0"

ENV PYENV_ROOT="/opt/pyenv" \
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
    netbase \
    pkg-config \
    wget \
    xz-utils \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone -b $PYENV_VERSION_TAG --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && for version in $PYTHON_VERSIONS; do pyenv install $version; done \
    && pyenv global $PYTHON_VERSIONS \
    && pip install $COMMON_SETUP_DEPENDENCIES \
    && pip install $COMMON_TEST_DEPENDENCIES \
 && rm -rf /tmp/*

VOLUME /src
WORKDIR /src
