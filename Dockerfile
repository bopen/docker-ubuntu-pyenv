FROM ubuntu:16.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ARG DEBIAN_FRONTEND="noninteractive"

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

COPY pyenv-version.txt python-versions.txt /
COPY requirements-setup.txt requirements-pytest.txt requirements-tox.txt /

RUN git clone -b `cat /pyenv-version.txt` --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && for version in `cat /python-versions.txt`; do pyenv install $version; done \
    && pyenv global `cat /python-versions.txt` \
    && pip install -r /requirements-setup.txt \
    && pip install -r /requirements-pytest.txt \
    && pip install -r /requirements-tox.txt \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rf '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -f '{}' + \
 && rm -rf /tmp/*
