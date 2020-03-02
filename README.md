# Homegrown content addressable media file system

Can you hobble together a content addressable media file system with open-source tools 'just laying around'? Yes, you can!

This solution doesn't scale, but it works for me as a single user.

To get right to it, go straight to [Setup](#setup).

#### Git

If our data store (file name and other metadata) is a plain text file, we just eliminated any file-syncing issues. It's a global and distributed solution.

#### IPFS

IPFS is good. You can create a private network and avoid syncing media files. The problem is finding files by name or other metadata, like tags. There is IPNS and File API, but it's too complicated for my use case here.

#### Jrnl

You can tag anything via cli. It uses a plain text file, which is perfect for git, and its easy to search.

## Setup

#### Setup a private IPFS network

https://github.com/7db9a/private-ipfs-docker

#### Install jrnl

https://jrnl.sh/installation/

#### Create a git repo for journal

```
mkdir -p journals/content-addressables/
cd journals/content-addressable-files/
git init
```

All the tags, and metadata of your IPFS files will be here. You may want to version control this.

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

***WARNING: skip this part and refer to jrnl's instructsion [here](https://jrnl.sh/advanced/). `Create jrnl config file` is dated. Looks like `jrnl` uses a yaml file now.***

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
alias jfgc="cd ~/path/to/journal/content-addressable-files && git add content-addressable-content-addressable-files.txt && git commit -m 'New entry or entries.' && cd -"
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

## Usage

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

```
jfgc
jfgp
```
`jrnl @FILE-NAME` or `jrnl @FILE-NAME @[OTHER-TAG] -and` to get the file hash.


#### Open or play the file

If it's a non-media file.

`docker exec ipfs_host ipfs cat IPFS-HASH`

If it's a video, for demonstration purposes:

`http://localhost:8080/ipfs/IPFS-HASH`

You can download the file on the other machine on that local webpage.

For more details on accessing your ipfs videos, see [here](https://docs.ipfs.io/guides/examples/videos/)
