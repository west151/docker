# Use Ubuntu 20.04 LTS as the basis for the Docker image.
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Upgrade system and Yocto Proyect basic dependencies
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib g++-multilib \
                  build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
                  xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales mc libncurses5-dev \
                  python3-distutils libdb5.3++-dev tzdata zstd lz4

# Replace dash with bash
RUN rm /bin/sh && ln -s bash /bin/sh

# Set up locales
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME user
ENV PROJECT snake

# User management
ARG host_uid=1000
ARG host_gid=1000
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# set user name
USER $USER_NAME

ENV YOCTO_INSTALL_PATH /home/$USER_NAME/yocto-data/poky
ENV BUILD_OUTPUT_DIR /home/$USER_NAME/yocto-data/build

# mkdir
RUN mkdir -p $YOCTO_INSTALL_PATH
RUN mkdir -p $BUILD_OUTPUT_DIR

WORKDIR ${YOCTO_INSTALL_PATH}

# build image
CMD /bin/sh -c "source ./oe-init-build-env ../build && MACHINE=${YOCTO_MACHINE} bitbake ${YOCTO_IMAGE} && MACHINE=${YOCTO_MACHINE} bitbake ${YOCTO_SDK}"
