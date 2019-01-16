
# docker-bitcoind

A Docker configuration with sane defaults for running a fully-validating
Bitcoin node, based on [Alpine Linux](https://alpinelinux.org/).

Full support for regtest and [backup_agent](https://github.com/tiberiuc/docker_backup_agent)

Wallet notify support by running curl with the address from env `BTC_WALLET_NOTIFY` seding a JSON in format { "txid": "...txid..." }

## Quick start

Requires that [Docker be installed](https://docs.docker.com/engine/installation/) on the host machine.

```
# Create some directory where your bitcoin data will be stored.
$ mkdir /home/youruser/bitcoin_data

$ docker run --name bitcoind -d \
   --env 'BTC_RPCUSER=foo' \
   --env 'BTC_RPCPASSWORD=password' \
   --env 'BTC_TXINDEX=1' \
   --volume /home/youruser/bitcoin_data:/root/.bitcoin \
   -p 127.0.0.1:8332:8332 \
   --publish 8333:8333 \
   --publish 9191:9191 \
   tiberiuc/bitcoind

$ docker logs -f bitcoind
[ ... ]
```


## Configuration

A custom `bitcoin.conf` file can be placed in the mounted data directory.
Otherwise, a default `bitcoin.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| BTC_RPCUSER | btc |
| BTC_RPCPASSWORD | changemeplz |
| BTC_RPCPORT | 8332 |
| BTC_RPCALLOWIP | ::/0 |
| BTC_RPCCLIENTTIMEOUT | 30 |
| BTC_DISABLEWALLET | 1 |
| BTC_TXINDEX | 0 |
| BTC_TESTNET | 0 |
| BTC_REGTEST | 0 |
| BTC_DBCACHE | 0 |
| BTC_ZMQPUBHASHTX | tcp://0.0.0.0:28333 |
| BTC_ZMQPUBHASHBLOCK | tcp://0.0.0.0:28333 |
| BTC_ZMQPUBRAWTX | tcp://0.0.0.0:28333 |
| BTC_ZMQPUBRAWBLOCK | tcp://0.0.0.0:28333 |
| BTC_WALLET_NOTIFY |  |


## Daemonizing

Currently bitcoind is run inside supervisor

## Backup and restore

Backup
```
curl http://localhost:9191/backup -o bitcoin.tgz
```

Restore
```
curl http://localhost:9191/restore --data-binary @./bitcoin.tgz
```
