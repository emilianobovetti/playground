DOCKER_TAG := alchymist:0

.PHONY: all docker docker-build

all: docker

docker: docker-build
	docker run \
		--rm \
		--tty \
		--interactive \
		--volume=$(HOME)/.Xauthority:/home/alchymist/.Xauthority:rw \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix \
		--env=DISPLAY=$(DISPLAY) \
		--hostname=$(shell cat /etc/hostname) \
		$(DOCKER_TAG) \
		bash

docker-build:
	docker build \
		--build-arg=uid=$(id -u) \
		--build-arg=gid=$(id -g) \
		--tag=$(DOCKER_TAG) \
		$(PWD)
