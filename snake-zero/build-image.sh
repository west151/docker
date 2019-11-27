#!/bin/bash

CL_RED="\033[0;31m"
CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE=$(awk -F"=" '/NAME_IMAGE/ {print ($2)}' image.conf)
NAME_SDK=$(awk -F"=" '/NAME_SDK/ {print ($2)}' image.conf)
MACHINE=$(awk -F"=" '/MACHINE/ {print ($2)}' image.conf)

echo
echo -e "${CL_RED}NAME_IMAGE:${CL_NC}" $NAME_IMAGE
echo -e "${CL_RED}NAME_SDK:${CL_NC}" $NAME_SDK
echo -e "${CL_RED}MACHINE:${CL_NC}" $MACHINE
echo
echo -e "${CL_GREEN}Run docker${CL_NC}"
echo

docker run --user=user:user -it --rm \
--env YOCTO_MACHINE=$MACHINE \
--env YOCTO_IMAGE=$NAME_IMAGE \
--env YOCTO_SDK=$NAME_SDK \
-v $PWD/yocto-data:/home/user/yocto-data yocto-image:latest

exit 0
