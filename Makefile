build:
	docker build -t fp/shell .

run: build
	docker run --rm --cap-add SYS_ADMIN --device /dev/fuse -it fp/shell  
	
install:
    ./setup.sh

.PHONY: build run install
