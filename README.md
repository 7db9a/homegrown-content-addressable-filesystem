# Homegrown content addressable media file system

For experimental purposes, can you hobble together a content addressable media file system that does the following with open-source tools 'just laying around'?

* Retreive files on any node without syncing.

* Files searchable by tags and other metadata from ***any*** machine on the network.

* Files aren't edited (on rare occasion you can edit the tags) , so mostly applicable to 'immutable' media files.

* Optionally backup nodes to a single server.

I think you can. I use git, ipfs, and tmsu. It's a hack, but it works and I'm getting immediate benefits.

## Table of Contents

1. [Usage](#usage)
2. [Dependencies](#dependencies)
3. [Setup](#setup)
4. [Advanced usage](#advanced-usage)

## Usage

**Add a file. You'll need the ipfs hash it prints out.**

`content-addr add $filename`

**Create tags and metadata.**

`tmsu tag $ipfshash $tag...`

**Find a file hash on any node.**

`tmsu files $tag...`

**Find a name associated with a file hash on any node.**

`tmsu tags $ipfshash`

**Get all untagged files**

`tmsu untagged`

**Play or open a file on any node.**

`http://localhost:8080/ipfs/$ipfshash`

## Dependencies

To skip all this, go straight to [Setup](#setup).

### Git

If our data store (file name and other metadata) is a plain text file, we just eliminated any file-syncing issues. It's a global and distributed solution.

### IPFS

IPFS is good. You can create a private network and avoid syncing media files. The problem is finding files by name or other metadata, like tags. There is IPNS and IPFS does have an API for Mutable File System. In any case, it's too complicated at the moment for me to deal with. I need all the names to be the same on all the nodes. Syncing that is a bad idea for my use case. I'd rather push and pull to a central 'names repo'. That's where versioning TMSU's database comes in.

### TMSU

You can tag anything via cli. And it can create virtual-file system. It uses sqlite. That can act as a central 'names repo'. The single-file database should be easy to version control with git. Only one user is making entries, so throughput isn't an issue. And it will elimunate syncing issues.

If anyone has figured out how to push or pull ipfs' Mutable File System changes to central server, tell me and the world. Is [ipfs-blob-store](https://github.com/ipfs-shipyard/ipfs-blob-store) any bit useful for this? Again, the 'names repo' should be like a git repo. You should be able to push and pull changes to avoid syncing issues.

## Setup

### Clone this repo

```
git clone https://github.com/7db9a/homegrown-content-addressable-filesystem content-addressable-filesystem

```

Make the script executable.

`chmod +x content-addressable-filesystem/content-addr.sh`

The script is for the `content-addr` commands and related.

### Setup a private IPFS network

https://github.com/7db9a/private-ipfs-docker

### Setup TMSU

https://github.com/7db9a/tmsu-docker

### Add path and symlink

Add the following to your .bashrc or other something similar to your shell related file.

`export PRIV_IPFS_STAGE=/path/to/private-ipfs-docker/private-network-ipfs/staging`

Put in your own specific path `private-ipfs-docker/private-network-ipfs/staging`. You should have already setup the private ipfs network.

Symlink `content-addressable-filesystem`.

```
mkdir $HOME/.content-addressable-filesystem
cd .content-addressable-filesystem
ln -s /path/to/content-addressable-file-system/* .
```

Add executable to path.

```
sudo ln -s \
~/.content-addr-filesystem/content-addr.sh \
/usr/local/bin/content-addr
```

### Setup git repos for tag data

We version control the TMSU data, including it's db's.

#### 1. Create remote git (pick any node)

You must be able to ssh into it from all the other nodes. So maybe choose your bootsrap node.

```
mkdir -p /path/to/content-addressables/remote/pinned-files
cd /path/to/tmsu-db/content-addressable-files/remote/pinned-files
git init --bare
```

#### 2. Create git working repos on the all the nodes (even if it has the remote repo).

```
cd /path/to/content-addressables/working/pinned-files/
git remote add origin \
ssh://user@address/path/to/content-addressables/remote/pinned-files
```

Nodes push and pull to and from the same `remote`.

#### 3. Push first change to git remote.

On a single node:

`docker exec -it ipfs_host ipfs config show | grep PeerID`

Use the PeerID and create the following path.

```
mdkir -p /path/to/content-addressables/working/pinned-files/$PEER_ID
cd /path/to/content-addressables/working/pinned-files/$PEER_ID
```
Now run `../../../get-pinned.sh $PEER_ID`.

Then git commit and push changes.

```
gcmsg "update"
gp
```

#### 4. Repeat #3 on all the other nodes.

Repeat, but `git pull origin master` before pushing changes.

## Advanced usage

### Backup a node

To backup your ipfs data to any server you can ssh into (preferable a swarm peer).

```
content-addr backup \
$ssh-user $ssh-address \
/path/to/content-addressable-filesystem/node-backup/ipfs/$peer-id
```
If you don't have the path made already, you should make it on the backup server.

(Personal note: I saved my full command at `jrnl linux $content-addr @backup -and`).

$peer-id is the Peer ID of the node you are backing up. To get your Peer ID:

`docker exec -it ipfs_host id`

Doesn't backing up defeat the purpose of ipfs? No, this is a private network and if a node's hard-drive fails, you'll lose all its local ipfs files. Therefore, I prefer to backup each node to a single server.

### Touch files with IPFS hash

Using your nodes $PEER_ID.

$ ./get-pinned.sh $PEER_ID

The IPFS files it produces are 'null'. They are named after the IPFS hash. It's useful for tagging.

All the null-ipfs files will be placed into the git working directory of the $PEER_ID.

### Tag IPFS hash

All nodes tag against null-ipfs files. Each node pushes to the same remote. Therefore, **any** node can search for **any** file on the network against tags.

### Low-level usage

Make sure your ipfs-network is up. If you don't remember how, see [here](https://github.com/7db9a/private-ipfs-docker).

#### Add a file to ipfs.

Stage the file.

`cp /path/to/file /path/private-ipfs-docker/private-ipfs-network/staging/`

Add to ipfs.

`docker exec ipfs_host ipfs add /export/file`

You'll get a hash. Use that for the next step.


#### Open or play the file

If it's a non-media file.

`docker exec ipfs_host ipfs cat $ipfshash`

If it's a video.

`http://localhost:8080/ipfs/$ipfshash`

You can download the file on the other machine on that local webpage.

For more details on accessing your ipfs videos, see [here](https://docs.ipfs.io/guides/examples/videos/).
