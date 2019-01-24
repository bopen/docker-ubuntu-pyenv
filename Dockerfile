FROM ubuntu:18.04

MAINTAINER Alessandro Amici <a.amici@bopen.eu>

ARG DEBIAN_FRONTEND="noninteractive"

ENV PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:$PATH" \
    LC_ALL="C.UTF-8" \
    LANG="C.UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        libbz2-dev \
        libffi-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl1.0-dev \
        # libssl-dev \
        llvm \
        make \
        netbase \
        pkg-config \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY pyenv-version.txt python-versions.txt /

RUN git clone -b `cat /pyenv-version.txt` --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && for version in `cat /python-versions.txt`; do pyenv install $version; done \
    && pyenv global `cat /python-versions.txt` \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rf '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -f '{}' + \
    && echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc \
 && rm -rf /tmp/*

COPY requirements-setup.txt requirements-test.txt requirements-ci.txt /
RUN pip install -r /requirements-setup.txt \
    && pip install -r /requirements-test.txt \
    && pip install -r /requirements-ci.txt \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rf '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -f '{}' + \
 && rm -rf /tmp/*
