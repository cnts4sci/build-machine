FROM ethcscs/mpich:ub1804_cuda92_mpi314

## Uncomment the following lines if you want to build mpi yourself:
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        wget \
        gfortran \
        gcc       \
        g++       \
        zlib1g-dev \
        libopenblas-dev \
&& rm -rf /var/lib/apt/lists/*

# Install MPICH
RUN wget -q http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz \
&& tar xf mpich-3.1.4.tar.gz \
&& cd mpich-3.1.4 \
&& ./configure --enable-fortran --enable-fast=all,O3 --prefix=/usr \
&& make -j$(nproc) \
&& make install \
&& ldconfig    \
&& rm -rf ../mpich-3.1.4
