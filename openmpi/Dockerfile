# syntax=docker/dockerfile:1

ARG BASE_IMAGE
ARG RUNTIME_BASE_IMAGE

FROM ${BASE_IMAGE} AS toolchain-builder

WORKDIR /openmpi-build

# Build toolchains
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    gcc \
    g++ \
    make \
    libtool \
    autoconf \
    automake \
    gfortran \
    bzip2 \
    tar \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN wget -c -O openmpi.tar.gz https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.6.tar.gz && \
    mkdir -p openmpi && \
    tar xf openmpi.tar.gz -C openmpi --strip-components=1 && \
    cd openmpi && \
    ./configure --prefix=/opt/openmpi --enable-static --disable-shared && \
    make -j$(nproc) && \
    make install

# Compile Lapack
WORKDIR /lapack-build
ARG LAPACK_VERSION="3.10.1"

RUN wget -c -O lapack.tar.gz https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v${LAPACK_VERSION}.tar.gz && \
    mkdir -p lapack && \
    tar xf lapack.tar.gz -C lapack --strip-components=1 && \
    cd lapack && \
    cp INSTALL/make.inc.gfortran make.inc && \
    make lapacklib blaslib && \
    mkdir -p /usr/local/lapack/lib && \
    cp *.a /usr/local/lapack/lib

# As build-machine image, it is not actually a runtime
# but I do the runtime multi-stage build to minimize the size
# and for testing the integrity of the openmpi/lapack... static build and move
FROM ${RUNTIME_BASE_IMAGE}

# Copy build toolchains from the builder stage
COPY --from=toolchain-builder /opt/openmpi /opt/openmpi
COPY --from=toolchain-builder /usr/local/lapack /usr/local/lapack

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    gcc \
    g++ \
    make \
    libtool \
    autoconf \
    automake \
    gfortran \
    bzip2 \
    tar \
    git && \
    rm -rf /var/lib/apt/lists/*

# Set up environment variables for OpenMPI
ENV PATH="/opt/openmpi/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/openmpi/lib:$LD_LIBRARY_PATH"

# Compile QE (for test only)
ARG QE_VERSION="7.0"

RUN wget -c -O qe.tar.gz https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VERSION}/q-e-qe-${QE_VERSION}.tar.gz && \
    mkdir -p qe && \
    tar xf qe.tar.gz -C qe --strip-components=1 && \
    cd qe && \
    LAPACK_LIBS=/usr/local/lapack/lib/liblapack.a BLAS_LIBS=/usr/local/lapack/lib/librefblas.a ./configure -enable-static && \
    make -j8 pw && \
    make install

