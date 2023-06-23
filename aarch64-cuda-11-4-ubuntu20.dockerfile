FROM balenalib/jetson-orin-nx-xavier-nx-devkit-ubuntu:focal-build

ENV ARCH=aarch64 \
    HOSTCC=gcc \
    TARGET=ARMV8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    ninja-build \
    git \
    wget \
    zip \
    unzip \
    python3 \
    awscli \
    curl \
    crossbuild-essential-arm64 \
 && rm -rf /var/lib/apt/lists/*

# Update some tools
WORKDIR /tmp
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install cmake

# installing Python3 doesn't provide a vanilla python command and it's used later in the build.  Provide one.
RUN ln -s /usr/bin/python3.8 /usr/bin/python

COPY scripts/deb_ubuntu_ccache.sh /work/
RUN /work/deb_ubuntu_ccache.sh

COPY toolchains/aarch64-linux-gnu-toolchain.cmake /usr
ENV CMAKE_TOOLCHAIN_FILE=/usr/aarch64-linux-gnu-toolchain.cmake

WORKDIR /usr/local

RUN git clone --recursive -b v0.3.23 https://github.com/xianyi/OpenBLAS.git && \
    cd /usr/local/OpenBLAS && \
    make NOFORTRAN=1 -j $(nproc) && \ 
    make PREFIX=/usr/local install && \
    cd /usr/local && \
    rm -rf OpenBLAS

WORKDIR /
