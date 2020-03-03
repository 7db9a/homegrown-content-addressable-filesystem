#!/bin/bash

ipfs-cat() {
    docker exec \
    -it \
    ipfs_host \
    ipfs cat $1
}

ipfs-add() {
    docker exec \
    -it \
    ipfs_host \
    ipfs add \
    /export/$1
}

if [ "$1" == "cat" ]; then
    ipfs-cat $2
fi

if [ "$1" == "add" ]; then
    ipfs-add $2
fi
