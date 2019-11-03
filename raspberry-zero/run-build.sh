#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE="snake-zboard-image"
NAME_SDK="meta-toolchain-qt5"

echo
echo -e "${CL_GREEN}Run build yocto poky.${CL_NC}"
echo

YOCTO_BRANCH="warrior"
QT_VER="5.13"

echo
echo -e "${CL_GREEN}  1. Git clone or update.${CL_NC}"
echo

if ! [ -d $(pwd)/poky ];
then
    echo -e "${CL_YELLOY}Clone poky${CL_NC}"
    echo
    git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git poky
    cd poky
    git clone -b master https://github.com/west151/meta-snake-zero
    git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded
    git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-raspberrypi
    git clone -b $QT_VER git://code.qt.io/yocto/meta-qt5.git
else
    echo -e "${CL_YELLOY}Update poky:${CL_NC}" $YOCTO_BRANCH
    cd $(pwd)/poky
    git fetch
    git pull origin
    #
    echo
    echo -e "${CL_YELLOY}Update meta-snake-zero:${CL_NC}" $YOCTO_BRANCH
    cd meta-snake-zero
    git fetch
    git pull origin
    #
    echo
    echo -e "${CL_YELLOY}Update meta-openembedded:${CL_NC}" $YOCTO_BRANCH
    cd ../meta-openembedded
    git fetch
    git pull origin
    #
    echo
    echo -e "${CL_YELLOY}Update meta-raspberrypi:${CL_NC}" $YOCTO_BRANCH
    cd ../meta-raspberrypi
    git fetch
    git pull origin
    #
    echo
    echo -e "${CL_YELLOY}Update meta-qt5:${CL_NC}" $QT_VER
    cd ../meta-qt5
    git fetch
    git pull origin
fi

# создаем папку "build" для совместного использования с контенером 
cd ../../
if ! [ -d $(pwd)/build ];
then
    # mkdir build
    mkdir build
    mkdir -p build/conf
fi

# копируем конфигурационные файлы
cp poky/meta-snake-zero/conf/bblayers.conf.docker build/conf/bblayers.conf
cp poky/meta-snake-zero/conf/local.conf.example build/conf/local.conf

echo
echo -e "${CL_GREEN}  2. Docker prune${CL_NC}"
echo
docker system prune -f
docker image prune -f

# build docker image
echo
echo -e "${CL_GREEN}  3. Build docker image${CL_NC}"
echo
docker build --no-cache . --tag snake-zboard-image:latest

# run docker
echo
echo -e "${CL_GREEN}  4. Run docker${CL_NC}"
echo
docker run --user=user:user -it --rm \
--env YOCTO_IMAGE=$NAME_IMAGE \
--env YOCTO_SDK=$NAME_SDK \
-v $PWD/build:/home/user/build snake-zboard-image:latest

exit 0
