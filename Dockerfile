# https://hub.docker.com/_/alpine
ARG alpine_ver=3.22
FROM alpine:${alpine_ver}

ARG build_rev=1


# Install Rsync, SSH and others.
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-client-default sshpass \
            gettext-envsubst \
            ca-certificates tzdata \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*
