ansible:
	./ansible_install.sh

ifeq ($(OS),Windows_NT)
DOCKER_BUILD_SCRIPT = .
DOCKER_RUN_SCRIPT = powershell -File docker_run.ps1
else
DOCKER_BUILD_SCRIPT = .
DOCKER_RUN_SCRIPT = ./docker_run.sh
endif

build_docker:
	$(DOCKER_BUILD_SCRIPT)


run_docker: build_docker
	$(DOCKER_RUN_SCRIPT)

.PHONY: ansible build_docker run_docker
