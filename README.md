# Cardano Docker Images

## Usage

### Run passive node

```
docker run \
  --rm -d \
  --name passive-node \
  -v $PWD/passive/db:/root/.cardano/db \
  -v $PWD/.inout:/inout \
  -p 3001:3001 publicstake/cardano-mainnet:1.24.2 \
  cardano-node run
```

#### Query tip

```
docker exec passive-node cardano-cli query tip \
  --mainnet
```

#### Generate payment key pair

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli address key-gen \
    --verification-key-file /inout/payment.vkey \
    --signing-key-file /inout/payment.skey
```

#### Generate stake key pair

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli stake-address key-gen \
    --verification-key-file /inout/stake.vkey \
    --signing-key-file /inout/stake.skey
```

#### Generate payment address

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli address build \
    --payment-verification-key-file /inout/payment.vkey \
    --stake-verification-key-file /inout/stake.vkey \
    --out-file /inout/payment.addr \
    --mainnet
```

#### Generate stake address

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli address build \
    --payment-verification-key-file /inout/payment.vkey \
    --stake-verification-key-file /inout/stake.vkey \
    --out-file /inout/stake.addr \
    --mainnet
```

#### Query the balance of an address

```
docker exec passive-node cardano-cli query utxo \
  --address $(cat .inout/payment.addr) \
  --mainnet \
  --allegra-era
```

#### Query protocol parameters

```
docker exec passive-node cardano-cli query protocol-parameters \
  --out-file /inout/protocol.json \
  --mainnet \
  --allegra-era
```

#### Get the transaction hash and index of the UTXO to spend

```
docker exec passive-node cardano-cli query utxo \
  --address $(cat .inout/payment.addr) \
  --mainnet \
  --allegra-era
```

### Generate Cold Keys and a Cold_counter

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli node key-gen \
    --cold-verification-key-file /inout/cold.vkey \
    --cold-signing-key-file /inout/cold.skey \
    --operational-certificate-issue-counter-file /inout/cold.counter
```

### Generate VRF Key pair

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli node key-gen-VRF \
    --verification-key-file /inout/vrf.vkey \
    --signing-key-file /inout/vrf.skey
```

### Generate KES Key pair

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 \
  cardano-cli node key-gen-KES \
    --verification-key-file /inout/kes.vkey \
    --signing-key-file /inout/kes.skey
```

### Generate the Operational Certificate


#### Generate the certificate

```
export KES_PERIOD=$(expr `docker exec passive-node cardano-cli query tip --mainnet | jq ".slotNo"` / `docker exec passive-node cat /root/.cardano/config/mainnet-shelley-genesis.json | jq ".slotsPerKESPeriod"`)
```

```
docker run \
  --rm \
  -v $PWD/.inout:/inout \
  publicstake/cardano:1.24.2 cardano-cli node issue-op-cert \
    --kes-verification-key-file /inout/kes.vkey \
    --cold-signing-key-file /inout/cold.skey \
    --operational-certificate-issue-counter /inout/cold.counter \
    --kes-period "$KES_PERIOD" \
    --out-file /inout/node.cert
```

### Create .env

```
touch .env
echo NODE_CERT=$(cat .inout/node.cert | jq -j ".cborHex") >> .env
echo KES_SKEY=$(cat .inout/kes.skey | jq -j ".cborHex") >> .env
echo VRF_SKEY=$(cat .inout/vrf.skey | jq -j ".cborHex") >> .env
```

### Move secrets to a secure location

Find a suitable location for secrets and clean .inout directory


## Build locally

```
docker build --tag publicstake/cardano-base:1.24.2 cardano-base
docker build --tag publicstake/cardano:1.24.2 cardano
docker build --tag publicstake/cardano-mainnet:1.24.2 cardano-mainnet
```