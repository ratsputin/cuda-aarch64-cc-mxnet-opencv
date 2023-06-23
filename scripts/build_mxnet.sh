git clone https://github.com/apache/incubator-mxnet ./mxnet
cd mxnet
git checkout tags/1.9.1
git submodule update --init --recursive

ln -s /usr/bin/python3.8 /usr/bin/python
mkdir build_aarch64_cuda
cd build_aarch64_cuda

# CMAKE_TOOLCHAIN_FILE is set in docker image.
cmake\
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
  -DUSE_OPENMP=ON \
  -DUSE_BLAS=Open \
  -DUSE_CUDA=ON\
  -DUSE_CUDNN=ON\
  -DMXNET_CUDA_ARCH="8.7"\
  -DENABLE_CUDA_RTC=OFF\
  -DCMAKE_BUILD_TYPE=Release\
  -DUSE_F16C=OFF\
  -GNinja\
  -DUSE_LAPACK=OFF\
  -DUSE_JEMALLOC=OFF\
  -DUSE_CPP_PACKAGE=ON\
  -DUSE_SIGNAL_HANDLER=OFF\
  -DUSE_OPENCV=OFF\
  -DUSE_MKL_IF_AVAILABLE=OFF\
  -DUSE_MKLDNN=OFF\
  -DBUILD_CPP_EXAMPLES=OFF\
  -DCMAKE_INSTALL_PREFIX=./packaged\
  ..

cmake --build . -j $(nproc) 
cmake --build . --target install
