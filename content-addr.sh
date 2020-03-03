#!/bin/bash

ipfs-cat() {
    docker exec \
    -it \
    ipfs_host \
    ipfs cat $1
}

if [ "$1" == "cat" ]; then
    ipfs-cat $2
fi
