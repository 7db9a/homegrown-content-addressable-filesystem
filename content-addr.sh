#!/bin/bash

# You must add the PRIV_IPFS_STAGE environmental variable to your .bashrc (or the file for whichever shell you use).
#
# export PRIV_IPFS_STAGE=/path/to/private-ipfs-docker/private-network-ipfs/staging
# export PRIV_IPFS_DATA=/path/to/private-ipfs-docker/private-network-ipfs/data
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

# Get your peers ip addresses.
# $ docker exec ipfs_host ipfs swarm peers

# rsync ipfs data to backup server.
# You'll need ssh access into the server.

rsync-node() {
    # $1 is the user, $2 is the address, and $3 is the path to the backup.
    # Example SRC DEST: data-dir /home/user/
    # In the above example, dir is synced to /home/user/data-dir
    rsync -azP --delete -e ssh $PRIV_IPFS_DATA $1@$2:$3
}

if [ "$1" == "backup" ]; then
    rsync-node $2 $3 $4
fi

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
