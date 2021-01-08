FROM ubuntu:20.04

ENV CARDANO_VERSION 1.24.2
ENV CABAL_VERSION 3.2.0.0
ENV GHC_VERSION 8.10.2
ENV LIBSODIUM_REF 66f017f1
ENV TZ=Etc/UTC
ENV PATH /root/.local/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p /root/.local/bin

RUN BUILD_PACKAGES="automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf" \
    && apt-get update -y \
    && apt-get install -y netbase \
    && apt-get install -y $BUILD_PACKAGES \
    && AUTO_ADDED_PACKAGES=`apt-mark showauto` \
    && wget https://downloads.haskell.org/~cabal/cabal-install-$CABAL_VERSION/cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz \
    && tar -xf cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz \
    && rm cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz cabal.sig \
    && mv cabal /root/.local/bin/ \
    && cabal update \
    && mkdir -p /tmp/build/ghc \
    && cd /tmp/build/ghc \
    && wget https://downloads.haskell.org/ghc/$GHC_VERSION/ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && tar -xf ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && rm ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && cd ghc-$GHC_VERSION \
    && ./configure \
    && find /usr/local | sort -u > /tmp/snapshot1 \
    && make install \
    && find /usr/local | sort -u > /tmp/snapshot2 \
    && mkdir -p /tmp/build/libsodium \
    && cd /tmp/build/libsodium \
    && git clone https://github.com/input-output-hk/libsodium \
    && cd libsodium \
    && git checkout $LIBSODIUM_REF \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && mkdir -p /tmp/build/cardano-node \
    && cd /tmp/build/cardano-node \
    && git clone https://github.com/input-output-hk/cardano-node.git \
    && cd cardano-node \
    && git fetch --all --recurse-submodules --tags \
    && git tag \
    && git checkout tags/$CARDANO_VERSION \
    && cabal configure --with-compiler=ghc-$GHC_VERSION \
    && echo "package cardano-crypto-praos" >>  cabal.project.local \
    && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
    && cabal build all \
    && cp -p dist-newstyle/build/x86_64-linux/ghc-$GHC_VERSION/cardano-node-$CARDANO_VERSION/x/cardano-node/build/cardano-node/cardano-node /root/.local/bin/ \
    && cp -p dist-newstyle/build/x86_64-linux/ghc-$GHC_VERSION/cardano-cli-$CARDANO_VERSION/x/cardano-cli/build/cardano-cli/cardano-cli /root/.local/bin/ \
    && comm -3 /tmp/snapshot1 /tmp/snapshot2 | xargs rm -rf \
    && rm /tmp/snapshot1 /tmp/snapshot2 \
    && rm -rf /root/.cabal \
    && rm /root/.local/bin/cabal \
    && apt-get remove --purge -y $BUILD_PACKAGES $AUTO_ADDED_PACKAGES \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/build

