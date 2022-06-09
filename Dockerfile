# https://hub.docker.com/_/alpine
ARG alpine_ver=3.16
FROM alpine:${alpine_ver}

ARG build_rev=1

LABEL org.opencontainers.image.source="\
    https://github.com/instrumentisto/rsync-ssh-docker-image"


# Install rsync and SSH.
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-client-default \
            sshpass \
            ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
