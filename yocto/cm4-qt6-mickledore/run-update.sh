#!/bin/bash

CL_RED="\033[0;31m"
CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

NAME_IMAGE=$(awk -F"=" '/NAME_IMAGE/ {print ($2)}' image.conf)
YOCTO_BRANCH=$(awk -F"=" '/YOCTO_BRANCH/ {print ($2)}' image.conf)
CUSTOM_META_BRANCH=$(awk -F"=" '/CUSTOM_META_BRANCH/ {print ($2)}' image.conf)
QT_VER=$(awk -F"=" '/QT_VER/ {print ($2)}' image.conf)

time=$(date +%s)

echo
echo -e "${CL_RED}YOCTO_BRANCH:${CL_NC}" $YOCTO_BRANCH
echo -e "${CL_RED}QT_VER:${CL_NC}" $QT_VER
echo

if ! [ -d $(pwd)/yocto-data/$NAME_IMAGE ];
then
    mkdir -p yocto-data/$NAME_IMAGE
fi

cd $(pwd)/yocto-data/$NAME_IMAGE

echo -e "${CL_GREEN}git clone or update.${CL_NC}"
echo

if ! [ -d $(pwd)/poky ];
 then
   echo -e "${CL_YELLOY}clone poky${CL_NC}"
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git poky
   echo
   git clone -b $CUSTOM_META_BRANCH git@github.com:west151/meta-snake.git poky/meta-snake
   echo
   git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded poky/meta-openembedded
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-raspberrypi poky/meta-raspberrypi
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-security poky/meta-security
   echo
   git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-virtualization poky/meta-virtualization
   echo
   git clone -b $QT_VER git://code.qt.io/yocto/meta-qt6.git poky/meta-qt6
 else
   echo -e "${CL_YELLOY}update poky:${CL_NC}" $YOCTO_BRANCH
   git -C poky fetch && git -C poky pull origin

   # meta-virtualization
   echo
   echo -e "${CL_YELLOY}update meta-virtualization:${CL_NC}" $YOCTO_BRANCH
   if ! [ -d $(pwd)/poky/meta-virtualization ];
     then
       git -C poky clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-virtualization
     else
       git -C poky/meta-virtualization fetch && git -C poky/meta-virtualization pull origin
   fi
   # meta-security
   echo
   echo -e "${CL_YELLOY}update meta-security:${CL_NC}" $YOCTO_BRANCH
   if ! [ -d $(pwd)/poky/meta-security ];
     then
       git -C poky clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-security
     else
       git -C poky/meta-security fetch && git -C poky/meta-security pull origin
   fi
   # meta-snake
   echo
   echo -e "${CL_YELLOY}update meta-snake:${CL_NC}" $CUSTOM_META_BRANCH
   if ! [ -d $(pwd)/poky/meta-snake ];
     then
       git -C poky clone -b $CUSTOM_META_BRANCH git@github.com:west151/meta-snake.git
     else
       git -C poky/meta-snake fetch && git -C poky/meta-snake pull origin
   fi
   # meta-openembedded
   echo
   echo -e "${CL_YELLOY}update meta-openembedded:${CL_NC}" $YOCTO_BRANCH
   git -C poky/meta-openembedded fetch && git -C poky/meta-openembedded pull origin
   # meta-raspberrypi
   echo
   echo -e "${CL_YELLOY}update meta-raspberry:${CL_NC}" $YOCTO_BRANCH
   if ! [ -d $(pwd)/poky/meta-raspberrypi ];
     then
       git -C poky clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-raspberrypi
     else
       git -C poky/meta-raspberrypi fetch && git -C poky/meta-raspberrypi pull origin
   fi
   # meta-qt6
   echo
   echo -e "${CL_YELLOY}update meta-qt6:${CL_NC}" $QT_VER
   if ! [ -d $(pwd)/poky/meta-qt6 ];
     then
       git -C poky clone -b $QT_VER git://code.qt.io/yocto/meta-qt6.git
     else
       git -C poky/meta-qt6 fetch && git -C poky/meta-qt6 pull origin
   fi
fi

# создаем папку "build" для совместного использования с контенером 
if ! [ -d $(pwd)/build ];
 then
   # mkdir build
   mkdir build
   mkdir -p build/conf
fi

echo
echo -e "${CL_GREEN}copy bblayers.conf and local.conf${CL_NC}"
echo

# копируем конфигурационные файлы
cp poky/meta-snake/conf/bblayers.conf.$NAME_IMAGE build/conf/bblayers.conf
cp poky/meta-snake/conf/local.conf.$NAME_IMAGE build/conf/local.conf

secs=$(($(date +%s)-$time))
printf -v ts '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

echo -e "${CL_GREEN}elapsed time: ${CL_NC}" $ts

exit 0
