#!/bin/bash

CL_RED="\033[0;31m"
CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE=$(awk -F"=" '/NAME_IMAGE/ {print ($2)}' image.conf)
NAME_SDK=$(awk -F"=" '/NAME_SDK/ {print ($2)}' image.conf)
YOCTO_BRANCH=$(awk -F"=" '/YOCTO_BRANCH/ {print ($2)}' image.conf)
QT_VER=$(awk -F"=" '/QT_VER/ {print ($2)}' image.conf)
MACHINE=$(awk -F"=" '/MACHINE/ {print ($2)}' image.conf)

echo 
echo -e "${CL_RED}NAME_IMAGE:${CL_NC}" $NAME_IMAGE
echo -e "${CL_RED}NAME_SDK:${CL_NC}" $NAME_SDK
echo -e "${CL_RED}YOCTO_BRANCH:${CL_NC}" $YOCTO_BRANCH
echo -e "${CL_RED}QT_VER:${CL_NC}" $QT_VER
echo -e "${CL_RED}MACHINE:${CL_NC}" $MACHINE

echo
echo -e "${CL_GREEN}Run build yocto poky.${CL_NC}"
echo

if ! [ -d $(pwd)/yocto-data ];
then
    mkdir yocto-data
fi

cd $(pwd)/yocto-data

echo -e "${CL_GREEN} 1. Git clone or update.${CL_NC}"
echo

if ! [ -d $(pwd)/poky ];
 then
   echo -e "${CL_YELLOY}Clone poky${CL_NC}"
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git poky
   echo
   cd poky
   git clone -b $YOCTO_BRANCH https://github.com/west151/meta-snake-pi4
   echo
   git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-raspberrypi
   echo
   git clone -b $QT_VER git://code.qt.io/yocto/meta-qt5.git
   #
   cd ../
 else
   echo -e "${CL_YELLOY}Update poky:${CL_NC}" $YOCTO_BRANCH
   cd poky
   git fetch
   git pull origin
   #
   echo
   echo -e "${CL_YELLOY}Update meta-snake-pi4:${CL_NC}" $YOCTO_BRANCH
   cd meta-snake-pi4
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
   #
   cd ../../
fi

# создаем папку "build" для совместного использования с контенером 
if ! [ -d $(pwd)/build ];
 then
   # mkdir build
   mkdir build
   mkdir -p build/conf
fi

# копируем конфигурационные файлы
cp poky/meta-snake-pi4/conf/bblayers.conf.docker build/conf/bblayers.conf
cp poky/meta-snake-pi4/conf/local.conf.example build/conf/local.conf

exit 0
