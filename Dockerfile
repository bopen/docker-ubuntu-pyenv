FROM ubuntu:16.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ARG PYENV_VERSION_TAG="v1.2.2"
ARG PYTHON_VERSIONS="3.6.4 3.5.5 3.4.8 pypy3.5-5.10.1 2.7.14 pypy2.7-5.10.0"
ARG DEBIAN_FRONTEND="noninteractive"
ARG COMMON_SETUP_DEPENDENCIES="cython==0.28 numpy==1.14.2 pip==9.0.2 pytest-runner==4.0 setuptools==38.6.0"
ARG COMMON_PYTEST_DEPENDENCIES="pytest==3.4.2 pytest-cov==2.5.1 pytest-flakes==2.0.0 pytest-mock==1.7.1"
ARG COMMON_TOX_DEPENDENCIES="detox==0.11 tox==2.9.1 tox-pyenv==1.1.0"

ENV PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:/opt/pyenv/shims:$PATH" \
    LC_ALL="C.UTF-8" \
    LANG="C.UTF-8"

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
    && pip install $COMMON_PYTEST_DEPENDENCIES \
    && pip install $COMMON_TOX_DEPENDENCIES \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -fv '{}' + \
 && rm -rf /tmp/*
