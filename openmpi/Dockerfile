# syntax=docker/dockerfile:1

# Compile openMPI
FROM base-image AS openmpi-builder

WORKDIR /openmpi-build
ARG OPENMPI_VERSION

# TODO: v4.1 -< OPENMPI_MAJOR_MINOR_VERSION
RUN wget -c -O openmpi.tar.gz https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${OPENMPI_VERSION}.tar.gz && \
    mkdir -p openmpi && \
    tar xf openmpi.tar.gz -C openmpi --strip-components=1 && \
    cd openmpi && \
    ./configure --prefix=/opt/openmpi --enable-static --disable-shared && \
    make -j$(nproc) && \
    make install && \
    rm -rf /openmpi-build

