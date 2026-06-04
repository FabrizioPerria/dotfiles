ifeq ($(OS),Windows_NT)
DOCKER_RUN_SCRIPT = pwsh -File docker_run.ps1
else
DOCKER_RUN_SCRIPT = ./docker_run.sh
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
	docker build --tag devenv:latest .

run_docker: build_docker
	$(DOCKER_RUN_SCRIPT)

.PHONY: ansible build_docker run_docker nvim shell tmux
