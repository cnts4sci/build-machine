# syntax=docker/dockerfile:1
FROM base-image

# Build toolchains
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    gcc \
    g++ \
    make \
    cmake \
    libtool \
    autoconf \
    automake \
    gfortran \
    bzip2 \
    tar \
    git && \
    rm -rf /var/lib/apt/lists/*
