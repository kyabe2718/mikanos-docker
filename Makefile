MAKEFILE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

IMAGE_NAME := mikanos-docker
VERSION := v0.1

define VOLUME_TEMPLATE
 -v $(1)
endef

VOLUMES := $(MAKEFILE_DIR)mikanos:/root/mikanos $(MAKEFILE_DIR)build/edk2:/root/edk2/Build

.PHONY: docker-build
docker-build:
	docker build . -t $(IMAGE_NAME):$(VERSION)

OPTIONS :=
CMD := /bin/bash
WORKDIR := /root

.PHONY: docker-run
docker-run:
	docker run --rm --privileged $(OPTIONS) -it $(foreach v, $(VOLUMES), $(call VOLUME_TEMPLATE, $(v))) --workdir=$(WORKDIR) $(IMAGE_NAME):$(VERSION) $(CMD)

build/edk2/MikanLoaderX64:
	$(MAKE) docker-run CMD="/bin/bash -c 'cd /root/edk2 && source edksetup.sh && build --platform=MikanLoaderPkg/MikanLoaderPkg.dsc --buildtarget=DEBUG --arch=X64 --tagname=CLANG38'" WORKDIR=/root

.PHONY: MikanLoader
MikanLoader: build/edk2/MikanLoaderX64

mikanos/disk.img:
	$(MAKE) docker-run CMD="/bin/bash -c 'source /root/osbook/devenv/buildenv.sh && ./build.sh'" WORKDIR=/root/mikanos

.PHONY: image
image: mikanos/disk.img

X11_OPTIONS := --net host -e DISPLAY=$(DISPLAY) -v $(HOME)/.Xauthority:/root/.Xauthority
run-qemu: build/edk2/MikanLoaderX64 mikanos/disk.img
	xhost +local:
	$(MAKE) docker-run CMD="../osbook/devenv/run_image.sh disk.img" OPTIONS="$(X11_OPTIONS)" WORKDIR=/root/mikanos
	xhost -local:

clean:
	cd mikanos && rm -rf disk.img ./mnt
	cd mikanos/kernel && rm -f kernel.elf hankaku.bin *.o .*.d *.swp
	rm -rf ./build
