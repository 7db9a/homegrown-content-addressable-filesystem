# Homegrown content addressable media file system

For experimental purposes, can you hobble together a content addressable media file system with open-source tools 'just laying around'? Yes, you can!

* No duplicate files thanks to ipfs hash.

* No file syncing between your machines.

* Files searchable by tags and other metadata and from any machine.

* Files aren't edited (on rare occassions you can edit the tags) , so mostly media files.

## Table of Contents

1. [Usage](#usage)
2. [Dependencies](#dependencies)
3. [Setup](#setup)
4. [Low-level usage](#low-level-usage)

## Usage

**Add a file. You'll need the ipfs hash it prints out.**

`content-addr add $filename`

**Create tags and metadata.**

`jrnl file 'any metadata or descriptions here @$filename @$othertag @$ipfshash'`

**Commit and push changes to jrnl.**

`jfgc && jfgp`

**Find a file hash on any node.**

`jrnl file @$filename`

`jrnl file @$filename @#othertag -and`

**Find a name associated with a file hash on any node.**

`jrnl file @ipfshash`

**Play or open a file on any node.**

`http://localhost:8080/ipfs/$ipfshash`

## Dependencies

To skip all this, go straight to [Setup](#setup).

#### Git

If our data store (file name and other metadata) is a plain text file, we just eliminated any file-syncing issues. It's a global and distributed solution.

#### IPFS

IPFS is good. You can create a private network and avoid syncing media files. The problem is finding files by name or other metadata, like tags. There is IPNS and I saw something about [Files API](https://www.youtube.com/watch?v=FX_AXNDsZ9k&t=315s), but I have know idea if Files API is implemented. In any case, it's too complicated at the moment for me to deal with.

#### Jrnl

You can tag anything via cli. It uses a plain text file, which is perfect for git, and it's easy to search.

## Setup

#### Clone this repo

```
git clone https://github.com/7db9a/homegrown-content-addressable-filesystem content-addressable-filesystem

```

Make the script executable.

`chmod +x content-addressable-filesystem/content-addr.sh`

The script is for the `content-addr` commands and related.

#### Setup a private IPFS network

https://github.com/7db9a/private-ipfs-docker

#### Add path and symlink

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

#### Install jrnl

https://jrnl.sh/installation/

#### Create a git repo for journal

```
mkdir -p journals/content-addressables/
cd journals/content-addressable-files/
git init
```

All the tags and other metadata on your IPFS files will be here. You may want to version control this.

#### Setup remote git repo (optional)

If you want to version the tags and metadata, may I recommend a private git server. It's easy.

On any other machine of yours.

```
mkdir -p /path/to/journals/content-addressables/
cd /path/to/journals/content-addressable-files/
git init --bare
```

Then back to your original machine:

```
cd /path/to/journals/content-addressables/
git remote add origin \
ssh://user@address/path/to/journals/content-addressables/`
```
#### Create jrnl config file

***WARNING: skip this part and refer to jrnl's instructions [here](https://jrnl.sh/advanced/). `Create jrnl config file` is dated. Looks like `jrnl` uses a yaml file now.***

`jrnl` will look for a $HOME/.jrnl_config.

Add this to the file.

```
{
  "default_hour": 9,
  "timeformat": "%Y-%m-%d %H:%M",
  "linewrap": 79,
  "encrypt": false,
  "editor": "vim",
  "default_minute": 0,
  "highlight": true,
  "journals": {
    "file": "$HOME/journals/content-addressable-files/content-addressable-files.txt",
  },
  "tagsymbols": "@"
```

#### Create aliases (optional)

If you are version controlling the tags and other metadata (recommended), you should create some aliases for git operations.

This works for me in bash and zsh.

```
# git commit
alias jfgc="cd ~/path/to/journal/content-addressable-files && git add content-addressable-files.txt && git commit -m 'New entry or entries.' && cd -"
# git diff
alias jfgd="cd ~/path/to/journal/content-addressable-files && git diff && cd -"
# git diff --check
alias jfgdc="cd ~/path/to/journal/content-addressable-files && git diff --check && cd -"
# git log
alias jfgl="cd ~/path/to/journal/content-addressable-files && git log && cd -"
# git push
alias jfgp="cd ~/path/to/journal/content-addressable-files && git push origin master && cd -"
# git status
alias jfgs="cd ~/path/to/journal/content-addressable-files && git status && cd -"
```

## Low-level usage.

Make sure your ipfs-network is up. If you don't remember how, see [here](https://github.com/7db9a/private-ipfs-docker).

#### Add a file to ipfs.

Stage the file.

`cp /path/to/file /path/private-ipfs-docker/private-ipfs-network/staging/`

Add to ipfs.

`docker exec ipfs_host ipfs add /export/file`

You'll get a hash. Use that for the next step.


#### Tag and create metadata

`jrnl file 'This is a file that does awesome stuff. @FILE-NAME @[OTHER-TAG]  @IPFS-HASH'` Now you can do

See the file diff.

`jfgd`

If it looks good, go ahead and git commit and push.

`jfgc && jfgp`

#### Find files by tags and metadata

To retreive a hash based on tags and metadata.

`jrnl file @FILE-NAME` or `jrnl file @FILE-NAME @[OTHER-TAG] -and` to get the file hash.

If you want to search by 'metadata', just open up

`~/path/to/journal/content-addressable-files/content-addressable-files.txt`

and search using your editor. It's not very elegant, but this is homegrown and experimental.

#### Open or play the file

If it's a non-media file.

`docker exec ipfs_host ipfs cat $ipfshash`

If it's a video.

`http://localhost:8080/ipfs/$ipfshash`

You can download the file on the other machine on that local webpage.

For more details on accessing your ipfs videos, see [here](https://docs.ipfs.io/guides/examples/videos/).
