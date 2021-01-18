FROM publicstake/cardano-build-node:1.24.2 AS build

FROM publicstake/cardano-base:latest

ENV CARDANO_VERSION 1.24.2
ENV TEMPLATES_PATH /root/.templates
ENV CARDANO_NODE_CONFIG_PATH /root/.cardano/config
ENV CARDANO_NODE_DB_PATH /root/.cardano/db
ENV CARDANO_NODE_SOCKET_PATH /root/.cardano/node.socket
ENV CARDANO_NODE_PORT 3001
ENV CARDANO_NODE_HOST_ADDRESS 0.0.0.0

RUN apt-get update -y \
  && apt-get install -y gettext-base jq  \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin
COPY --from=build /tmp/build/cardano-node/dist-newstyle/build/x86_64-linux/ghc-$GHC_VERSION/cardano-node-$CARDANO_VERSION/x/cardano-node/build/cardano-node/cardano-node .
COPY --from=build /tmp/build/cardano-node/dist-newstyle/build/x86_64-linux/ghc-$GHC_VERSION/cardano-cli-$CARDANO_VERSION/x/cardano-cli/build/cardano-cli/cardano-cli .
COPY entrypoint.sh /usr/local/bin/
COPY rest-config.json /root/.cardano/config/
COPY topology.json /root/.cardano/config/
COPY templates /root/.templates
RUN chmod 400 -R /root/.cardano/config \
  && chmod 400 -R /root/.templates

ENTRYPOINT ["entrypoint.sh"]