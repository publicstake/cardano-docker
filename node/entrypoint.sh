#!/bin/bash
set -e

if [ -n "${TOPOPLOGY_JSON}" ]; then
  echo $TOPOPLOGY_JSON > $NODE_CONFIG_PATH/topology.json;
fi

if [ -n "${COLD_COUNTER}" ]; then
  envsubst < "${TEMPLATES_PATH}/cold.counter.tmpl" > "$NODE_CONFIG_PATH/cold.counter"
fi

if [ -n "${COLD_SKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/cold.skey.tmpl" > "$NODE_CONFIG_PATH/cold.skey"
fi

if [ -n "${COLD_VKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/cold.vkey.tmpl" > "$NODE_CONFIG_PATH/cold.vkey"
fi

if [ -n "${KES_SKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/kes.skey.tmpl" > "$NODE_CONFIG_PATH/kes.skey"
fi

if [ -n "${KES_VKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/kes.vkey.tmpl" > "$NODE_CONFIG_PATH/kes.vkey"
fi

if [ -n "${VRF_SKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/vrf.skey.tmpl" > "$NODE_CONFIG_PATH/vrf.skey"
fi

if [ -n "${VRF_VKEY}" ]; then
  envsubst < "${TEMPLATES_PATH}/vrf.vkey.tmpl" > "$NODE_CONFIG_PATH/vrf.vkey"
fi

if [ -n "${NODE_CERT}" ]; then
  envsubst < "${TEMPLATES_PATH}/node.cert.tmpl" > "$NODE_CONFIG_PATH/node.cert"
fi


if [ "$1" = 'run' ]; then

  config_args=(
    "--config ${NODE_CONFIG_PATH}/config.json"
    "--topology ${NODE_CONFIG_PATH}/topology.json"
    "--database-path ${NODE_DB_PATH}"
    "--socket-path ${NODE_SOCKET_PATH}"
    "--host-addr ${NODE_HOST_ADDRESS}"
    "--port ${NODE_PORT}"
  );

  if [ -n "${KES_SKEY}" ]; then
    config_args+=("--shelley-kes-key ${NODE_CONFIG_PATH}/kes.skey")
  fi

  if [ -n "${VRF_SKEY}" ]; then
    config_args+=("--shelley-vrf-key ${NODE_CONFIG_PATH}/vrf.skey")
  fi

  if [ -n "${NODE_CERT}" ]; then
    config_args+=("--shelley-operational-certificate ${NODE_CONFIG_PATH}/node.cert")
  fi

  args=$(IFS=' '; echo "${config_args[*]} ${@:2}")
  exec cardano-node run $args
fi

if [ "$1" = 'issue-op-cert' ]; then

  config_args=();

  if [ -n "${KES_VKEY}" ]; then
    config_args+=("--kes-verification-key-file ${NODE_CONFIG_PATH}/keys.vkey")
  fi

  if [ -n "${COLD_SKEY}" ]; then
    config_args+=("--cold-signing-key-file ${NODE_CONFIG_PATH}/cold.skey")
  fi

  if [ -n "${COLD_COUNTER}" ]; then
    config_args+=("--operational-certificate-issue-counter ${NODE_CONFIG_PATH}/cold.counter")
  fi

  args=$(IFS=' '; echo "${config_args[*]} ${@:2}")
  exec cardano-node run $args
fi

exec cardano-node "$@"