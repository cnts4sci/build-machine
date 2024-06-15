# The build machine with all toolchains

We are building two images the `ghcr.io/cnts4sci/openmpi` and `ghcr.io/cnts4sci/mpich`.
The images is used as the base image for other software build.
In the image, we provide as much as possible the regular math libraries as we can:

- Lapack
- FFTW
- Libxc
- ..??

