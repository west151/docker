#!/bin/bash

CL_GREEN="\033[0;32m"
CL_YELLOY="\033[0;33m"
CL_NC="\033[0m"

echo
echo -e "${CL_GREEN}Docker prune${CL_NC}"
echo
docker system prune -f
docker image prune -f

#cd ../

# build docker image
echo
echo -e "${CL_GREEN}Build docker image${CL_NC}"
echo
docker build --no-cache . --tag snake-pi4-image:latest

exit 0
