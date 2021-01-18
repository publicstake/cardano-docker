FROM publicstake/cardano-builder:latest

ENV CARDANO_VERSION 1.24.2

WORKDIR  /tmp/build

RUN git clone https://github.com/input-output-hk/cardano-node.git cardano-node \
    && cd cardano-node \
    && git fetch --all --recurse-submodules --tags \
    && git tag \
    && git checkout tags/$CARDANO_VERSION \
    && cabal configure --with-compiler=ghc-$GHC_VERSION \
    && echo "package cardano-crypto-praos" >>  cabal.project.local \
    && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local \
    && cabal build all

