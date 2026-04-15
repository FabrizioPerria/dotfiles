ifeq ($(OS),Windows_NT)
DOCKER_RUN_SCRIPT = powershell -File docker_run.ps1
TC_URL           = $(shell powershell -Command '$$env:TEAMCITY_URL')
TC_TOKEN         = $(shell powershell -Command '$$env:TEAMCITY_TOKEN')
P4_URL           = $(shell powershell -Command '$$env:P4URL')
P4_USER          = $(shell powershell -Command '$$env:P4USER')
else
DOCKER_RUN_SCRIPT = ./docker_run.sh
TC_URL            = $(TEAMCITY_URL)
TC_TOKEN          = $(TEAMCITY_TOKEN)
P4_URL            = $(P4URL)
P4_USER           = $(P4USER)
endif

ansible:
	./ansible_install.sh

build_docker:
	docker build \
		--build-arg TC_URL=$(TC_URL) \
		--build-arg TC_TOKEN=$(TC_TOKEN) \
		--build-arg P4URL=$(P4_URL) \
		--build-arg P4USER=$(P4_USER) \
		--build-arg P4CLIENT="fabriziop-linux" \
		--tag devenv:latest .

run_docker: build_docker
	$(DOCKER_RUN_SCRIPT)

.PHONY: ansible build_docker run_docker
