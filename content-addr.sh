#!/bin/bash

# You must add the PRIV_IPFS_STAGE environmental variable to your .bashrc (or the file for whichever shell you use).
#
# export PRIV_IPFS_STAGE=/path/to/private-ipfs-docker/private-network-ipfs/staging
#

send-file-to-ipfs() {
    stage-file $1
    ipfs-add $1
}

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

stage-file() {
    cp $(pwd)/$1 $PRIV_IPFS_STAGE/$1
}

# Porcelain cmd
if [ "$1" == "add" ]; then
    send-file-to-ipfs $2
fi

# Plumbing cmd
if [ "$1" == "ipfs-cat" ]; then
    ipfs-cat $2
fi

# Plumbing cmd
if [ "$1" == "ipfs-add" ]; then
    ipfs-add $2
fi

# Plumbing cmd
if [ "$1" == "stage-file" ]; then
    stage-file $2
fi
