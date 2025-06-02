Rsync + SSH Docker image
========================

[![Release](https://img.shields.io/github/v/release/instrumentisto/rsync-ssh-docker-image "Release")](https://github.com/instrumentisto/rsync-ssh-docker-image/releases)
[![CI](https://github.com/instrumentisto/rsync-ssh-docker-image/actions/workflows/ci.yml/badge.svg?branch=main "CI")](https://github.com/instrumentisto/rsync-ssh-docker-image/actions?query=workflow%3ACI+branch%3Amain)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/rsync-ssh?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/rsync-ssh)

[Docker Hub](https://hub.docker.com/r/instrumentisto/rsync-ssh)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/rsync-ssh)
| [Quay.io](https://quay.io/repository/instrumentisto/rsync-ssh)

[Changelog](https://github.com/instrumentisto/rsync-ssh-docker-image/blob/main/CHANGELOG.md)




## Supported tags and respective `Dockerfile` links

- [`alpine3.22-r0`, `alpine3.22`, `alpine`, `latest`][d1]




## Supported platforms

- `linux`: `amd64`, `arm32v6`, `arm32v7`, `arm64v8`, `i386`, `ppc64le`, `s390x`




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
    rsync -avz <remote-host>:<remote-src-path> /mnt/
```

Transferring file from remote host without `rsync` to local host with `rsync`:
```bash
rsync -avz --rsync-path="docker run --rm -i -v <remote-src-path>:/mnt instrumentisto/rsync-ssh rsync" \
    <remote-host>:/mnt/ <local-dest-path>
```

Transfer file from remote host without `rsync` to local host without `rsync`:
```bash
docker run --rm -i -v <local-dest-path>:/mnt instrumentisto/rsync-ssh \
    rsync -avz --rsync-path="docker run --rm -i -v <remote-src-path>:/mnt instrumentisto/rsync-ssh rsync" \
        <remote-host>:/mnt/ /mnt/
```




## Image tags


### `alpine`

Latest tag of the latest [Alpine][1] version.

This image is based on the popular [Alpine Linux project][1], available in [the alpine official image][2]. [Alpine Linux][1] is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This is a multi-platform image.


### `alpine<X.Y>`

Latest tag of the latest minor `X.Y` [Alpine][1] version.

This is a multi-platform image.


### `alpine<X.Y>-r<N>`

Concrete `N` image revision tag of the concrete minor `X.Y` [Alpine][1] version.

Once built, it's never updated.

This is a multi-platform image.


### `alpine<X.Y>-r<N>-<os>-<arch>`

Concrete `N` image revision tag of the concrete minor `X.Y` [Alpine][1] version on the concrete `os` and `arch`.

Once built, it's never updated.

This is a single-platform image.




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

[1]: http://alpinelinux.org
[2]: https://hub.docker.com/_/alpine

[10]: https://github.com/instrumentisto/rsync-ssh-docker-image/issues

[91]: https://github.com/instrumentisto/rsync-ssh-docker-image/blob/main/LICENSE.md
[92]: https://github.com/instrumentisto/rsync-ssh-docker-image
[93]: https://pserver.samba.org/rsync/GPL.html
[94]: https://github.com/openssh/openssh-portable/blob/master/LICENCE

[d1]: https://github.com/instrumentisto/rsync-ssh-docker-image/blob/main/Dockerfile
