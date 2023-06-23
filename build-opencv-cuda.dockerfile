FROM aarch64-cuda11-4

COPY scripts/build_opencv.sh / 

RUN ./build_opencv.sh
