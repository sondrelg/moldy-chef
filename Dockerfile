FROM lukemathwalker/cargo-chef:latest-rust-1

RUN mkdir /usr/bin/.config && touch /usr/bin/.config/cargo.toml  \
    && echo '[target.x86_64-unknown-linux-gnu]' > /usr/bin/.config/cargo.toml \
    && echo 'linker = "clang"' >> /usr/bin/.config/cargo.toml \
    && echo 'rustflags = ["-C", "link-arg=-fuse-ld=/usr/bin/mold"]' >> /usr/bin/.config/cargo.toml \
    && echo '[target.aarch64-unknown-linux-gnu]' > /usr/bin/.config/cargo.toml \
    && echo 'linker = "clang"' >> /usr/bin/.config/cargo.toml \
    && echo 'rustflags = ["-C", "link-arg=-fuse-ld=/usr/bin/mold"]' >> /usr/bin/.config/cargo.toml

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
