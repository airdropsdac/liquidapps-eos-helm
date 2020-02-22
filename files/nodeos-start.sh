#!/bin/bash
echo "JSR and SRS and ...."
apt-get update && apt-get install wget vim -y
DATADIR="/data1/EOSmainNet"
CONFIGDIR="/data1/EOSmainNet-config"
mkdir -p $DATADIR
mkdir -p $CONFIGDIR

cd $DATADIR
rm -rf state
# Download the latest snapshot
#wget $(wget --quiet "https://eosnode.tools/api/snapshots?limit=1" -O- | jq -r '.data[0].s3') -O snapshot.tar.gz
#wget https://snapshots.eossweden.org/snapshots/aca376/1.8/snapshot-104902428.bin.tar.gz -O snapshot.tar.gz
wget https://snapshots.eossweden.org/snapshots/aca376/1.8/snapshot-106364721.bin.tar.gz -O snapshot.tar.gz

# Uncompress
tar xvzf snapshot.tar.gz

echo -e "Starting Nodeos \n";

cp /data1/EOSmainNet-config/genesis.json /data1/EOSmainNet/
cp /data1/EOSmainNet-config/config.ini /data1/EOSmainNet/
nodeos --data-dir $DATADIR --config-dir $DATADIR --snapshot "$(ls -t *.bin | head -n1)" "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/nodeos.pid
sleep 10
tail -f $DATADIR/stderr.txt
