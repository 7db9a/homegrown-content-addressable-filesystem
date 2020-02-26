# Poor man's virtual content addressable media file system

Can you hobble together a virtual content addressable media file system with open-source tools 'just laying around'? Possibly.

* Find a file by name, tags, and description regardless of what machine it's on.

* No duplicate files.

* No file syncing and overwrite issues.

* Use git as a central tracker for file names and other metadata.

* Understandable, but abstractable.

### Git

If our data store (file name and other metadata) is a plain text file, we just eliminated any file-syncing issues. It's a global and disrtibuted solution.

### IPFS

IPFS is good. You can create a private network and avoid syncing media files. The problem is finding files by name or other metadata, like tags. Is it possible to use IPNS (naming scheme, basically) privately? I don't know. It's kind of a lot to take in. Anyway, it doesn't solving taging and attaching other metadata to the file. So let's just use IPFS and forget about IPNS for this use-case. There is also File API for IPFS that can help you manage mutating files. Again, it's a bit much to take in for something quick, although it looks very interesting. In any case, I don't want to manage mutable media files. I'm not editing my pdf books and downloaded Youtube videos. Regardless, I don't see why something like File API related tool can't be used if it makes sense in the future.

### Jrnl

You can tag anything via cli. It uses a plain text file, which is perfect for git, and its easy to search.
