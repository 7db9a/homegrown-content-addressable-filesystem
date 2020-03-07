#!/bin/bash

PEER_ID=$1

PINNED_DIR=working/pinned-files/$PEER_ID

ipfs-pinned() {
    docker exec ipfs_host ipfs pin ls --type=recursive -q
}

IFS=$'\r
' GLOBIGNORE='*' command eval  'PINNED=($(ipfs-pinned))'

for i in "${PINNED[@]}"
do
   # do whatever on $i
   touch $PINNED_DIR/$i
done
