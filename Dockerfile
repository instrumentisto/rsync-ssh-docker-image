# https://hub.docker.com/_/alpine/
FROM alpine:3.10

MAINTAINER Instrumentisto Team <developer@instrumentisto.com>


RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            rsync \
            openssh-client \
 && rm -rf /var/cache/apk/*
