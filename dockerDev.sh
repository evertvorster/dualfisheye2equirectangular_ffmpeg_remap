#!/bin/bash
# refresh repo
# build docker images
docker build -t lwonprom-dev -f docker/dev.docker docker
echo " COMPILING  --------------------------"
docker run \
  --mount type=bind,source="$PWD",target=/srv/lwonprom \
  -u $(id -u):$(id -g) \
  -ti lwonprom-dev /bin/bash 
