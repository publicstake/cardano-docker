#!/bin/bash
set -e

if [ -n "${TOPOPLOGY_JSON}" ]; then
  echo $TOPOPLOGY_JSON > $CARDANO_NODE_CONFIG_PATH/topology.json;
fi

if [ -n "${KES_SKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/kes.skey.tmpl" > "$CARDANO_NODE_CONFIG_PATH/kes.skey"
fi

if [ -n "${VRF_SKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/vrf.skey.tmpl" > "$CARDANO_NODE_CONFIG_PATH/vrf.skey"
fi

if [ -n "${NODE_CERT}" ]; then
  envsubst < "${TEMPLATES_PATH}/node.cert.tmpl" > "$CARDANO_NODE_CONFIG_PATH/node.cert"
fi

chmod 400 -R $CARDANO_NODE_CONFIG_PATH

if [ "$1" = 'cardano-node' ]; then
  if [ "$2" = 'run' ]; then
    # cardano-node run
    config_args=(
      "--config ${CARDANO_NODE_CONFIG_PATH}/config.json"
      "--topology ${CARDANO_NODE_CONFIG_PATH}/topology.json"
      "--database-path ${CARDANO_NODE_DB_PATH}"
      "--socket-path ${CARDANO_NODE_SOCKET_PATH}"
      "--host-addr ${CARDANO_NODE_HOST_ADDRESS}"
      "--port ${CARDANO_NODE_PORT}"
    )

    if [ -n "${KES_SKEY}" ]; then
      config_args+=("--shelley-kes-key ${CARDANO_NODE_CONFIG_PATH}/kes.skey")
    fi

    if [ -n "${VRF_SKEY}" ]; then
      config_args+=("--shelley-vrf-key ${CARDANO_NODE_CONFIG_PATH}/vrf.skey")
    fi

    if [ -n "${NODE_CERT}" ]; then
      config_args+=("--shelley-operational-certificate ${CARDANO_NODE_CONFIG_PATH}/node.cert")
    fi

    args=$(IFS=' '; echo "${config_args[*]} ${@:3}")
    exec cardano-node run $args
  fi
fi

exec "$@"