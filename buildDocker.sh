#!/bin/bash
# refresh repo
# sudo rm -Rf docker/dfe2er
# git clone . docker/dfe2er
# # build docker images
# docker build -t dfe2er-compile -f docker/compile.docker docker
# #echo " COMPILING  --------------------------"
# sudo docker run \
#   --mount type=bind,source="$PWD/docker/dfe2er",target=/app \
#   -ti dfe2er-compile || exit 1
# cp docker/dfe2er/data/Original/*tif data/Original
#echo " TESTING  --------------------------"
docker build -t dfe2er -f docker/app.docker docker
