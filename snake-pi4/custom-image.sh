#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

echo
echo -e "${CL_GREEN}Run custom yocto poky.${CL_NC}"
echo
echo -e "${CL_GREEN}init build env:${CL_NC}"
echo -e "${CL_YELLOY}  source ./oe-init-build-env ../build${CL_NC}"
echo

docker run -it --rm --user=user:user \
 -v $PWD/yocto-data:/home/user/yocto-data yocto-custom-image:latest /bin/bash

exit 0
