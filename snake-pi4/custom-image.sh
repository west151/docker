#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE=$(awk -F"=" '/NAME_IMAGE/ {print ($2)}' image.conf)
NAME_SDK=$(awk -F"=" '/NAME_SDK/ {print ($2)}' image.conf)
YOCTO_BRANCH=$(awk -F"=" '/YOCTO_BRANCH/ {print ($2)}' image.conf)
QT_VER=$(awk -F"=" '/QT_VER/ {print ($2)}' image.conf)
MACHINE=$(awk -F"=" '/MACHINE/ {print ($2)}' image.conf)

echo
echo -e "${CL_GREEN}Run custom yocto poky.${CL_NC}"
echo
echo -e  "${CL_GREEN}Yocto branch: ${CL_NC}" $YOCTO_BRANCH
echo -e  "${CL_GREEN}Qt ver.: ${CL_NC}" $QT_VER
echo
echo -e "${CL_GREEN}init build env:${CL_NC}"
echo -e "${CL_YELLOY}  source ./oe-init-build-env ../build${CL_NC}"
echo
echo -e "${CL_GREEN}build image:${CL_NC}"
echo -e "${CL_YELLOY}  bitbake $NAME_IMAGE ${CL_NC}"
echo
echo -e "${CL_GREEN}build toolchain sdk:${CL_NC}"
echo -e "${CL_YELLOY}  bitbake $NAME_SDK ${CL_NC}"
echo

docker run -it --rm --user=user:user \
 -v $PWD/yocto-data:/home/user/yocto-data yocto-custom-image:latest /bin/bash

exit 0
