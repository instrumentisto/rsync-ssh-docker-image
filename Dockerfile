# https://hub.docker.com/_/alpine
ARG alpine_ver=3.18
FROM alpine:${alpine_ver}

ARG build_rev=0


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
