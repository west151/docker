# Use Ubuntu 18.04 LTS as the basis for the Docker image.
FROM ubuntu:18.04

# Upgrade system and Yocto Proyect basic dependencies
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
                  build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
                  xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales mc

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

ENV YOCTO_INSTALL_PATH /home/$USER_NAME
ENV BUILD_OUTPUT_DIR /home/$USER_NAME/build

# mkdir
RUN mkdir -p $BUILD_OUTPUT_DIR

WORKDIR ${BUILD_OUTPUT_DIR}

RUN mkdir -p conf

# Set the Yocto release
ENV YOCTO_RELEASE "warrior"
# Set the Qt version
ENV QT_RELEASE "5.13"

# Clone the repositories of the meta layers into the directory $YOCTO_INSTALL_PATH
WORKDIR ${YOCTO_INSTALL_PATH}

# Install Poky
RUN git clone -b ${YOCTO_RELEASE} git://git.yoctoproject.org/poky.git

WORKDIR poky

RUN git clone -b ${YOCTO_RELEASE} https://github.com/west151/meta-snake
RUN git clone -b ${YOCTO_RELEASE} git://git.openembedded.org/meta-openembedded
RUN git clone -b ${YOCTO_RELEASE} git://git.yoctoproject.org/meta-raspberrypi
RUN git clone -b ${QT_RELEASE} git://code.qt.io/yocto/meta-qt5.git

#COPY bblayers.conf ../build/conf/bblayers.conf
#COPY local.conf ../build/conf/local.conf

#
RUN cp $YOCTO_INSTALL_PATH/poky/meta-snake/conf/bblayers.conf.docker ../build/conf/bblayers.conf
RUN cp $YOCTO_INSTALL_PATH/poky/meta-snake/conf/local.conf.example ../build/conf/local.conf

#
#CMD /bin/sh -c "cp ./meta-snake/conf/bblayers.conf.docker ../build/conf/bblayers.conf"
#CMD /bin/sh -c "cp ./meta-snake/conf/local.conf.example ../build/conf/local.conf"

# WaveShare Compute Module IO Board Plus
CMD /bin/sh -c "source ./oe-init-build-env ../build && bitbake console-image"

# Prepare Yocto's build environment. If TEMPLATECONF is set, the script oe-init-build-env will
# install the customised files bblayers.conf and local.conf. This script initialises the Yocto
# build environment. The bitbake command builds the rootfs for our embedded device.
#WORKDIR $BUILD_OUTPUT_DIR
#ENV TEMPLATECONF=$BUILD_INPUT_DIR/$PROJECT/sources/meta-$PROJECT/custom
#CMD source $BUILD_INPUT_DIR/$PROJECT/sources/poky/oe-init-build-env build \
#    && bitbake $PROJECT-image

