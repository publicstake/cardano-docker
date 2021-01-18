FROM publicstake/cardano-base:latest

ENV CABAL_VERSION 3.2.0.0
ENV GHC_VERSION 8.10.2
ENV LIBSODIUM_REF 66f017f1
ENV PATH /root/.local/bin:$PATH
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
      autoconf

RUN wget https://downloads.haskell.org/~cabal/cabal-install-$CABAL_VERSION/cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz \
    && tar -xf cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz \
    && rm cabal-install-$CABAL_VERSION-x86_64-unknown-linux.tar.xz cabal.sig \
    && mv cabal /root/.local/bin/ \
    && cabal update

RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && wget https://downloads.haskell.org/ghc/$GHC_VERSION/ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && tar -xf ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && rm ghc-$GHC_VERSION-x86_64-deb9-linux.tar.xz \
    && cd ghc-$GHC_VERSION \
    && ./configure \
    && make install \
    && rm -rf /tmp/build

RUN  mkdir -p /tmp/build \
    && cd /tmp/build \
    && git clone https://github.com/input-output-hk/libsodium \
    && cd libsodium \
    && git checkout $LIBSODIUM_REF \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/build