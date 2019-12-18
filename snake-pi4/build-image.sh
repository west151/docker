#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE="console-image"
NAME_SDK="meta-toolchain-qt5"
MACHINE="raspberrypi4-64"

time=$(date +%s)

echo
echo -e "${CL_GREEN}Run build yocto poky.${CL_NC}"

# run docker
echo
echo -e "${CL_GREEN}Run docker${CL_NC}"
echo

docker run --user=user:user -it --rm \
--env YOCTO_MACHINE=$MACHINE \
--env YOCTO_IMAGE=$NAME_IMAGE \
--env YOCTO_SDK=$NAME_SDK \
-v $PWD/yocto-data:/home/user/yocto-data yocto-image:latest

secs=$(($(date +%s)-$time))
printf -v ts '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

echo -e "${CL_GREEN}elapsed time: ${CL_NC}" $ts

exit 0
