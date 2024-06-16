# syntax=docker/dockerfile:1

# Compile Lapack
FROM base-image AS lapack-builder

WORKDIR /lapack-build
ARG LAPACK_VERSION

RUN wget -c -O lapack.tar.gz https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v${LAPACK_VERSION}.tar.gz && \
    mkdir -p lapack && \
    tar xf lapack.tar.gz -C lapack --strip-components=1 && \
    cd lapack && \
    cp INSTALL/make.inc.gfortran make.inc && \
    make lapacklib blaslib && \
    mkdir -p /usr/local/lapack/lib && \
    cp *.a /usr/local/lapack/lib && \
    rm -rf /lapack-build

