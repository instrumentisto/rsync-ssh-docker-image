Rsync + SSH Docker image
========================

[![Release](https://img.shields.io/github/v/release/instrumentisto/rsync-ssh-docker-image "Release")](https://github.com/instrumentisto/rsync-ssh-docker-image/releases)
[![CI](https://github.com/instrumentisto/rsync-ssh-docker-image/workflows/CI/badge.svg?branch=master "CI")](https://github.com/instrumentisto/rsync-ssh-docker-image/actions?query=workflow%3ACI+branch%3Amaster)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/rsync-ssh?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/rsync-ssh)

[Docker Hub](https://hub.docker.com/r/instrumentisto/rsync-ssh)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/rsync-ssh)
| [Quay.io](https://quay.io/repository/instrumentisto/rsync-ssh)

[Changelog](https://github.com/instrumentisto/rsync-ssh-docker-image/blob/master/CHANGELOG.md)




## Supported tags and respective `Dockerfile` links

- [`alpine3.13-r4`, `alpine3.13`, `alpine`, `latest`][d1]




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




## License

Rsync is licensed under [GNU GPL version 3 license][93].  
OpenSSH Portable is licensed under [BSD licence][94].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][92] for producing `instrumentisto/rsync-ssh` Docker images are licensed under [Blue Oak Model License 1.0.0][91].




## Issues

We can't notice comments in the [DockerHub] (or other container registries) so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][10].





[DockerHub]: https://hub.docker.com

[10]: https://github.com/instrumentisto/rsync-ssh-docker-image/issues

[91]: https://github.com/instrumentisto/rsync-ssh-docker-image/blob/master/LICENSE.md
[92]: https://github.com/instrumentisto/rsync-ssh-docker-image
[93]: https://pserver.samba.org/rsync/GPL.html
[94]: https://github.com/openssh/openssh-portable/blob/master/LICENCE

[d1]: https://github.com/instrumentisto/rsync-ssh-docker-image/blob/master/Dockerfile
