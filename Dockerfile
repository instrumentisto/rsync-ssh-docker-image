# https://hub.docker.com/_/alpine
ARG alpine_ver=3.20
FROM alpine:${alpine_ver}

ARG build_rev=2


# Install Rsync and SSH.
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-client-default \
            sshpass \
            ca-certificates tzdata \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
