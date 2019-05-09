#!/bin/bash
# refresh repo
sudo rm -Rf docker/dfe2er
git clone . docker/dfe2er
# build docker images
docker build -t dfe2er-compile -f docker/compile.docker docker
#echo " COMPILING  --------------------------"
sudo docker run \
  --mount type=bind,source="$PWD/docker/dfe2er",target=/app \
  -ti dfe2er-compile || exit 1
#echo " TESTING  --------------------------"
#
##sudo docker run \
##  --mount type=bind,source="$PWD/docker/lwonprom",target=/srv/lwonprom \
##  -ti lwonprom-quiz || exit 1
##
#docker run \
#  --mount type=bind,source="$PWD/docker/lwonprom",target=/srv/lwonprom \
#  -ti lwonprom-emquiz || exit 1
##  -u $(id -u):$(id -g) \
