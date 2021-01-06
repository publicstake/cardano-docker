FROM ubuntu:20.04

ENV CARDANO_VERSION 1.24.2
ENV TZ=Etc/UTC
ENV PATH /root/.local/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p /root/.local/bin

RUN apt-get update -y \
    && apt-get install -y \
        automake \
        build-essential \
        pkg-config \
        libffi-dev \
        libgmp-dev \
        libssl-dev \
        libtinfo-dev \
        libsystemd-dev \
        zlib1g-dev \
        make \
        g++ \
        tmux \
        git \
        jq \
        wget \
        libncursesw5 \
        libtool \
        autoconf \
    && wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
    && tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz \
    && rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig \
    && mv cabal /root/.local/bin/ \
    && cabal update \
    && mkdir -p /temp/build/ghc \
    && cd /temp/build/ghc \
    && wget https://downloads.haskell.org/ghc/8.10.2/ghc-8.10.2-x86_64-deb9-linux.tar.xz \
    && tar -xf ghc-8.10.2-x86_64-deb9-linux.tar.xz \
    && rm ghc-8.10.2-x86_64-deb9-linux.tar.xz \
    && cd ghc-8.10.2 \
    && ./configure \
    && make install \
    && mkdir -p /temp/build/libsodium \
    && cd /temp/build/libsodium \
    && git clone https://github.com/input-output-hk/libsodium \
    && cd libsodium \
    && git checkout 66f017f1 \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && mkdir -p /temp/build/cardano-node \
    && cd /temp/build/cardano-node \
    && git clone https://github.com/input-output-hk/cardano-node.git \
    && cd cardano-node \
    && git fetch --all --recurse-submodules --tags \
    && git tag \
    && git checkout tags/$CARDANO_VERSION \
    && cabal configure --with-compiler=ghc-8.10.2 \
    && echo "package cardano-crypto-praos" >>  cabal.project.local \
    && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
    && cabal build all \
    && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-node-$CARDANO_VERSION/x/cardano-node/build/cardano-node/cardano-node /root/.local/bin/ \
    && cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-cli-$CARDANO_VERSION/x/cardano-cli/build/cardano-cli/cardano-cli /root/.local/bin/ \
    && rm -rf /temp/build \
    && rm /root/.local/bin/cabal \
    && apt-get purge -y \
        automake \
        build-essential \
        pkg-config \
        libffi-dev \
        libgmp-dev \
        libssl-dev \
        libtinfo-dev \
        libsystemd-dev \
        zlib1g-dev \
        make \
        g++ \
        tmux \
        git \
        jq \
        wget \
        libncursesw5 \
        libtool \
        autoconf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*