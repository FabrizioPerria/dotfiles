ifeq ($(OS),Windows_NT)
DOCKER_RUN_SCRIPT = pwsh -File docker_run.ps1
else
DOCKER_RUN_SCRIPT = ./docker_run.sh
endif

ansible:
	./ansible_install.sh

build_docker:
	docker build --tag devenv:latest .

run_docker: build_docker
	$(DOCKER_RUN_SCRIPT)

.PHONY: ansible build_docker run_docker
