###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)

# Maps platform identifier to the one accepted by Docker CLI.
dockerify = $(strip $(if $(call eq,$(1),linux/arm32v6),linux/arm/v6,\
                    $(if $(call eq,$(1),linux/arm32v7),linux/arm/v7,\
                    $(if $(call eq,$(1),linux/arm64v8),linux/arm64/v8,\
                                                       $(platform)))))




######################
# Project parameters #
######################

ALPINE_VER ?= $(strip \
	$(shell grep 'ARG alpine_ver=' Dockerfile | cut -d '=' -f2))
BUILD_REV ?= $(strip \
	$(shell grep 'ARG build_rev=' Dockerfile | cut -d '=' -f2))

NAME := rsync-ssh
OWNER := $(or $(GITHUB_REPOSITORY_OWNER),instrumentisto)
REGISTRIES := $(strip $(subst $(comma), ,\
	$(shell grep -m1 'registry: \["' .github/workflows/ci.yml \
	        | cut -d':' -f2 | tr -d '"][')))
TAGS ?= alpine$(ALPINE_VER)-r$(BUILD_REV) \
        alpine$(ALPINE_VER) \
        alpine \
        latest
VERSION ?= $(word 1,$(subst $(comma), ,$(TAGS)))




###########
# Aliases #
###########

image: docker.image

push: docker.push

release: git.release

test: test.docker




###################
# Docker commands #
###################

docker-registries = $(strip $(if $(call eq,$(registries),),\
                            $(REGISTRIES),$(subst $(comma), ,$(registries))))
docker-tags = $(strip $(if $(call eq,$(tags),),\
                      $(TAGS),$(subst $(comma), ,$(tags))))


docker-namespaces = $(strip $(if $(call eq,$(namespaces),),\
                            $(NAMESPACES),$(subst $(comma), ,$(namespaces))))
docker-platforms = $(strip $(if $(call eq,$(platforms),),\
                           $(PLATFORMS),$(subst $(comma), ,$(platforms))))

# Runs `docker buildx build` command allowing to customize it for the purpose of
# re-tagging or pushing.
define docker.buildx
	$(eval namespace := $(strip $(1)))
	$(eval tag := $(strip $(2)))
	$(eval platform := $(strip $(3)))
	$(eval no-cache := $(strip $(4)))
	$(eval args := $(strip $(5)))
	$(eval github_url := $(strip $(or $(GITHUB_SERVER_URL),https://github.com)))
	$(eval github_repo := $(strip $(or $(GITHUB_REPOSITORY),\
	                                   instrumentisto/rsync-ssh-docker-image)))
	docker buildx build --force-rm $(args) \
		--platform $(platform) \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg alpine_ver=$(ALPINE_VER) \
		--build-arg build_rev=$(BUILD_REV) \
		--label org.opencontainers.image.source=$(github_url)/$(github_repo) \
		--label org.opencontainers.image.revision=$(strip \
			$(shell git show --pretty=format:%H --no-patch)) \
		--label org.opencontainers.image.version=$(strip \
			$(shell git describe --tags --dirty)) \
		-t $(namespace)/$(NAME):$(tag) .
endef


# Build Docker image with the given tag.
#
# Usage:
#	make docker.image [tag=($(VERSION)|<docker-tag>)]] [no-cache=(no|yes)]
#	                  [platform=<os>/<arch>]
#	                  [ALPINE_VER=<alpine-version>]
#	                  [BUILD_REV=<build-revision>]

github_url := $(strip $(or $(GITHUB_SERVER_URL),https://github.com))
github_repo := $(strip $(or $(GITHUB_REPOSITORY),$(OWNER)/$(NAME)-docker-image))

docker.image:
	docker buildx build --force-rm \
		$(if $(call eq,$(platform),),,--platform $(call dockerify,$(platform)))\
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg alpine_ver=$(ALPINE_VER) \
		--build-arg build_rev=$(BUILD_REV) \
		--label org.opencontainers.image.source=$(github_url)/$(github_repo) \
		--label org.opencontainers.image.revision=$(strip \
			$(shell git show --pretty=format:%H --no-patch)) \
		--label org.opencontainers.image.version=$(strip \
			$(shell git describe --tags --dirty)) \
		--load -t $(OWNER)/$(NAME):$(or $(tag),$(VERSION)) ./


# Push Docker images to their repositories (container registries),
# along with the required multi-arch manifests.
#
# Usage:
#	make docker.push
#		[namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]
#		[tags=($(TAGS)|<tag-1>[,<tag-2>...])]
#		[platforms=($(PLATFORMS)|<platform-1>[,<platform-2>...])]
#		[ALPINE_VER=<alpine-version>]
#		[BUILD_REV=<build-revision>]

docker.push:
	$(foreach namespace,$(docker-namespaces),\
		$(foreach tag,$(docker-tags),\
			$(call docker.buildx,\
				$(namespace),\
				$(tag),\
				$(shell echo "$(docker-platforms)" | tr -s '[:blank:]' ','),,\
				--push)))


# Save Docker images to a tarball file.
#
# Usage:
#	make docker.tar [to-file=(.cache/image.tar|<file-path>)]
#	                [tags=($(VERSION)|<docker-tag-1>[,<docker-tag-2>...])]

docker-tar-file = $(or $(to-file),.cache/image.tar)

docker.tar:
	@mkdir -p $(dir $(docker-tar-file))
	docker save -o $(docker-tar-file) \
		$(foreach tag,$(subst $(comma), ,$(or $(tags),$(VERSION))),\
			$(OWNER)/$(NAME):$(tag))


docker.test: test.docker


# Load Docker images from a tarball file.
#
# Usage:
#	make docker.untar [from-file=(.cache/image.tar|<file-path>)]

docker.untar:
	docker load -i $(or $(from-file),.cache/image.tar)




####################
# Testing commands #
####################

# Run Bats tests for Docker image.
#
# Documentation of Bats:
#	https://github.com/bats-core/bats-core
#
# Usage:
#	make test.docker [tag=($(VERSION)|<docker-tag>)]
#	                 [platform=(linux/amd64|<os>/<arch>)]

test.docker:
ifeq ($(wildcard node_modules/.bin/bats),)
	@make npm.install
endif
	IMAGE=$(OWNER)/$(NAME):$(or $(tag),$(VERSION)) \
	PLATFORM=$(or $(call dockerify,$(platform)),linux/amd64) \
	node_modules/.bin/bats \
		--timing $(if $(call eq,$(CI),),--pretty,--formatter tap) \
		--print-output-on-failure \
		tests/main.bats




################
# NPM commands #
################

# Resolve project NPM dependencies.
#
# Usage:
#	make npm.install [dockerized=(no|yes)]

npm.install:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app/ -w /app/ \
		node \
			make npm.install dockerized=no
else
	npm install
endif




################
# Git commands #
################

# Release project version (apply version tag and push).
#
# Usage:
#	make git.release [ver=($(VERSION)|<proj-ver>)]

git-release-tag = $(strip $(if $(call eq,$(ver),),$(VERSION),$(ver)))

git.release:
ifeq ($(shell git rev-parse $(git-release-tag) >/dev/null 2>&1 && echo "ok"),ok)
	$(error "Git tag $(git-release-tag) already exists")
endif
	git tag $(git-release-tag) master
	git push origin refs/tags/$(git-release-tag)




##################
# .PHONY section #
##################

.PHONY: image push release test \
        docker.image docker.push docker.tar docker.test docker.untar \
        git.release \
        npm.install \
        test.docker
