FROM lukemathwalker/cargo-chef:latest-rust-1

ENV RUSTFLAGS="-C linker=clang link-arg=-fuse-ld=/usr/bin/mold"

WORKDIR app

ARG VERSION

RUN apt-get update && apt-get install git

RUN git clone https://github.com/rui314/mold.git \
    && mkdir mold/build \
    && cd mold/build \
    && git checkout "v$VERSION" \
    && ../install-build-deps.sh \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=c++ .. \
    && cmake --build . -j $(nproc) \
    && cmake --build . --target install \
    && cp mold /usr/bin/mold \
    && cd .. \
    && rm -rf ./mold
