FROM aarch64-cuda11-4

COPY scripts/build_mxnet.sh / 

RUN ./build_mxnet.sh
