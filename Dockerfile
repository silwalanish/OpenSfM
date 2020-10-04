FROM ubuntu:20.04 AS base

ARG DEBIAN_FRONTEND=noninteractive

# Install apt-getable dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    libeigen3-dev \
    libopencv-dev \
    libceres-dev \
    python3-dev \
    python3-numpy \
    python3-pip \
    python3-pyproj \
    python3-opencv \
    python3-scipy \
    python3-yaml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM base AS main

WORKDIR /OpenSfM

COPY . .

RUN pip3 install -r requirements.txt \
    && python3 setup.py install

ENV path="${PATH}:/OpenSfM/bin"

WORKDIR /root

RUN apt-get --purge remove -y \
    build-essential \
    cmake \
    && apt-get autoremove -y \
    && apt-get clean
