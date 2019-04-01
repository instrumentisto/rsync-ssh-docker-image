Rsync + SSH Docker Image
========================

[![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/rsync-ssh.svg)](https://hub.docker.com/r/instrumentisto/rsync-ssh) [![Based on](https://img.shields.io/badge/based%20on-alpine-blue.svg)][12] [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/instrumentisto/rsync-ssh-docker-image/blob/master/LICENSE.md)




## What is Rsync and SSH?

SSH (Secure Shell) is a cryptographic network protocol for operating network services securely over an unsecured network. The best known example application is for remote login to computer systems by users.

Rsync is a utility for efficiently transferring and synchronizing files across computer systems, by checking the timestamp and size of files. It is commonly found on Unix-like systems and functions as both a file synchronization and file transfer program. The rsync algorithm is a type of
delta encoding, and is used for minimizing network usage. Zlib may be used for additional compression, and SSH or stunnel can be used for data security.




## How to use this image

Just prepend `rsync`/`ssh` command with `docker run instrumentisto/rsync-ssh`:
```bash
docker run --rm -i instrumentisto/rsync-ssh rsync --help
```

Transferring data from volume to local folder:
```bash
docker run --rm -i -v <volume-name>:/volume -v $(pwd):/mnt instrumentisto/rsync-ssh \
    rsync -avz /volume/ /mnt/
```

Transferring file from remote host with `rsync` to local host without `rsync`:
```bash 
docker run --rm -i -v <local-dest-path>:/mnt instrumentisto/rsync-ssh \
    rsync -avz <remote host>:<remote soruce path> /mnt/
```

Transferring file from remote host without `rsync` to local host with `rsync`:
```bash
rsync -avz --rsync-path="docker run --rm -i -v <remote-src-path>:/mnt instrumentisto/rsync-ssh rsync" \
    <remote host>:/mnt/ <local-dest-path>
```

Transfer file from remote host without `rsync` to local host without `rsync`:
```bash
docker run --rm -i -v <local-dest-path>:/mnt instrumentisto/rsync-ssh \
    rsync -avz --rsync-path="docker run --rm -i -v <remote-src-path>:/mnt instrumentisto/rsync-ssh rsync" \
        <remote-host>:/mnt/ /mnt/
```




## Issues

We can't notice comments in the DockerHub, so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][10].





[10]: https://github.com/instrumentisto/rsync-ssh-docker-image/issues
[12]: https://hub.docker.com/_/alpine
