#!/bin/bash

PINNED_FILES=$(pwd)/pinned-files

ipfs-pinned() {
    docker exec ipfs_host ipfs pin ls --type=recursive -q
}

IFS=$'\r
' GLOBIGNORE='*' command eval  'PINNED=($(ipfs-pinned))'

for i in "${PINNED[@]}"
do
   # do whatever on $i
   touch $PINNED_FILES/$i
done
