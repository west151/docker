#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

WORK_DIR=$(pwd)
NAME_IMAGE=$(awk -F"=" '/NAME_IMAGE/ {print ($2)}' image.conf)
NAME_SDK=$(awk -F"=" '/NAME_SDK/ {print ($2)}' image.conf)
MACHINE=$(awk -F"=" '/MACHINE/ {print ($2)}' image.conf)
TARGET_DEPLOY=$(awk -F"=" '/TARGET_DEPLOY/ {print ($2)}' image.conf)
YOCTO_BRANCH=$(awk -F"=" '/YOCTO_BRANCH/ {print ($2)}' image.conf)
QT_VER=$(awk -F"=" '/QT_VER/ {print ($2)}' image.conf)
TARGET_SUBDIR=snake-cm4-qt6/${YOCTO_BRANCH}/qt-${QT_VER}

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
-v $PWD/yocto-data:/home/user/yocto-data yocto-image-v2:latest

echo -e "${CL_GREEN}Deploy image: ${CL_NC}"
echo

if [ -d ${TARGET_DEPLOY} ]; then
   #
   mkdir -p ${TARGET_DEPLOY}/${TARGET_SUBDIR}/$(date +%Y%m%d)
   #
   echo -e "${CL_GREEN}Copy image: ${CL_NC}"
   rsync --progress ${WORK_DIR}/yocto-data/build/tmp/deploy/images/raspberrypi4-64/*rootfs.rpi-sdimg ${TARGET_DEPLOY}/${TARGET_SUBDIR}/$(date +%Y%m%d)/
   #
   echo
   echo -e "${CL_GREEN}Copy sdk: ${CL_NC}"
   rsync --progress ${WORK_DIR}/yocto-data/build/tmp/deploy/sdk/*.sh ${TARGET_DEPLOY}/${TARGET_SUBDIR}/$(date +%Y%m%d)/
fi

secs=$(($(date +%s)-$time))
printf -v ts '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

echo -e "${CL_GREEN}elapsed time: ${CL_NC}" $ts

exit 0
