#!/bin/bash

echo "Run build yocto poky."

YOCTO_BRANCH="warrior"
QT_VER="5.13"

if ! [ -d $(pwd)/poky ];
then
    echo 'Clone poky'
    git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git poky
    cd poky
    #git clone -b $YOCTO_BRANCH https://github.com/west151/meta-snake-zero
    git clone -b master https://github.com/west151/meta-snake-zero
    git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded
    git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-raspberrypi
    git clone -b $QT_VER git://code.qt.io/yocto/meta-qt5.git
else
    echo 'Update poky:' $YOCTO_BRANCH
    cd $(pwd)/poky
    git fetch
    git pull origin
    #
    echo 'Update meta-snake-zero' $YOCTO_BRANCH
    cd meta-snake-zero
    git fetch
    git pull origin
    #
    echo 'Update meta-openembedded:' $YOCTO_BRANCH
    cd ../meta-openembedded
    git fetch
    git pull origin
    #
    echo 'Update meta-raspberrypi' $YOCTO_BRANCH
    cd ../meta-raspberrypi
    git fetch
    git pull origin
    #
    echo 'Update meta-qt5:' $QT_VER
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

docker system prune -f
docker image prune -f

# build docker image
#docker build . --tag snake-zboard-image:latest
docker build --no-cache . --tag snake-zboard-image:latest

# run docker
docker run --user=user:user -it --rm -v $PWD/build:/home/user/build snake-zboard-image:latest