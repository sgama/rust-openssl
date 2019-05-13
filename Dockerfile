FROM rust:latest

# We need musl-dev & musl-tools to perform static linking on our rust binaries
# Add all the env required to configure the static build.
ENV TOOLCHAIN=stable \
    OPENSSL_VERSION=1.0.2r \
    OPENSSL_DIR=/usr/local/musl/ \
    OPENSSL_INCLUDE_DIR=/usr/local/musl/include/ \
    DEP_OPENSSL_INCLUDE=/usr/local/musl/include/ \
    OPENSSL_LIB_DIR=/usr/local/musl/lib/ \
    OPENSSL_STATIC=1 \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    CC=musl-gcc \
    C_INCLUDE_PATH=/usr/local/musl/include/

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates build-essential libssl-dev musl-dev musl-tools && \
    echo "Building OpenSSL" && \
    curl -O https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz && \
    tar xvzf openssl-$OPENSSL_VERSION.tar.gz && cd openssl-$OPENSSL_VERSION && \
    ./Configure no-shared no-zlib -fPIC --prefix=/usr/local/musl linux-x86_64 && \
    make depend && \
    make && make install && \
    cd .. && rm -rf openssl-$OPENSSL_VERSION.tar.gz openssl-$OPENSSL_VERSION
