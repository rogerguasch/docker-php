.PHONY :

RED=\033[0;31m
GREEN=\033[0;32m
ORANGE=\033[0;33m
NC=\033[0m

# Setup ————————————————————————————————————————————————————————————————————————
current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# Folders ——————————————————————————————————————————————————————————————————————
current-dir 		:= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

## —— Build ————————————————————————————————————————————————————————————————————
build-php-image:
	docker build -t docker-php php/

build-php-image-no-cache:
	docker build -t docker-php php/ --no-cache

go-inside:
	docker exec -it docker-php /bin/bash

start-php-container:
	docker run -dp 3034:3034 docker-php