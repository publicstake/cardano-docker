FROM publicstake/cardano-builder:latest

ENV CARDANO_DB_SYNC_VERSION 7.1.0

WORKDIR /tmp/build

RUN git clone https://github.com/input-output-hk/cardano-db-sync.git \
    && cd cardano-db-sync \
    && git fetch --all --recurse-submodules --tags \
    && git tag \
    && git checkout $CARDANO_DB_SYNC_VERSION \
    && cabal configure --with-compiler=ghc-$GHC_VERSION \
    && echo "package cardano-crypto-class" >>  cabal.project.local \
    && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
    && cabal build all
