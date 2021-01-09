FROM ghcr.io/publicstake/cardano:1.24.2

ENV TEMPLATES_PATH /root/.templates
ENV CARDANO_NODE_CONFIG_PATH /root/.cardano/config
ENV CARDANO_NODE_DB_PATH /root/.cardano/db
ENV CARDANO_NODE_SOCKET_PATH /root/.cardano/node.socket
ENV CARDANO_NODE_PORT 3001
ENV CARDANO_NODE_HOST_ADDRESS 0.0.0.0

RUN apt-get update -y \
  && apt-get install -y gettext-base \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/
COPY rest-config.json /root/.cardano/config/
COPY topology.json /root/.cardano/config/
COPY templates /root/.templates

ENTRYPOINT ["entrypoint.sh"]