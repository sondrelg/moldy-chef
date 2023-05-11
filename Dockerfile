FROM lukemathwalker/cargo-chef:latest-rust-1

ENV RUSTFLAGS="-C linker=clang link-arg=-fuse-ld=/usr/bin/mold"

WORKDIR app

ARG VERSION
ARG ARCH

RUN apt-get update \
    && apt-get install clang -y \
    && wget -c https://github.com/rui314/mold/releases/download/v1.11.0/mold-${VERSION}-${ARCH}-linux.tar.gz -O - | tar -xz \
    && mv mold-${VERSION}-${ARCH}-linux/bin/mold /usr/bin/mold \
    && rm -rf mold-${VERSION}-${ARCH}-linux/bin/mold
