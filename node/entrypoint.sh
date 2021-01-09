#!/bin/bash
set -e

if [ -n "${TOPOPLOGY_JSON}" ]; then
  echo $TOPOPLOGY_JSON > $NODE_CONFIG_PATH/topology.json;
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

  args=$(IFS=' '; echo "${config_args[*]} ${@:2}")
  exec cardano-node run $args
fi

exec cardano-node "$@"