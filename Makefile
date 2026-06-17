ifeq ($(OS),Windows_NT)
DOCKER_RUN_SCRIPT = pwsh -File container_run.ps1
ARCH := x86_64
else
DOCKER_RUN_SCRIPT = ./container_run.sh
ARCH := $(shell uname -m)
endif

ifeq ($(ARCH),x86_64)
PODMAN_PLATFORM = linux/amd64
else
PODMAN_PLATFORM = linux/arm64
endif

ansible:
	./ansible_install.sh

nvim:
	rm -rf ~/.config/nvim
	cp -R nvim ~/.config

shell:
	rm -rf ~/.config/shell
	cp -R shell ~/.config
	echo "Reload zsh"

tmux:
	rm -rf ~/.config/tmux
	cp -R tmux ~/.config
	echo "Reload tmux"

build_docker:
	docker build --progress=plain --tag devenv:latest .

build_podman:
	podman build --platform $(PODMAN_PLATFORM) -t devenv:latest .

run_docker: build_docker
	CONTAINER_ENGINE=docker $(DOCKER_RUN_SCRIPT)

run_docker_notmux: build_docker
	NO_TMUX=1 CONTAINER_ENGINE=docker $(DOCKER_RUN_SCRIPT)

run_podman: 
	CONTAINER_ENGINE=podman $(DOCKER_RUN_SCRIPT)

.PHONY: ansible build_docker run_docker run_docker_notmux nvim shell tmux build_podman
