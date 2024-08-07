build:
	docker build -t fp/shell .

run: build
	docker run --rm --cap-add SYS_ADMIN \
		--device /dev/fuse \
		-v ~:/home/win \
		-v ~/.ssh:/home/fabrizio/.ssh \
		-v ~/.gitconfig:/home/fabrizio/.gitconfig \
		-v ~/.gnupg:/home/fabrizio/.gnupg \
		--security-opt apparmor:unconfined \
		--security-opt seccomp:unconfined \
		-it fp/shell  
    
install:
	./setup.sh

.PHONY: build run install
