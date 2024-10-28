# WVS_ROS2

This repository contains a Dockerfile to build a docker image that can be used to build the WVS_ROS2 nuget package.
The docker image cannot be shared because of the included Visual Studio build tools, Microsoft does not permit publishing images with VS Build tools.

## How to build the docker image
- install docker on your computer, see www.docker.com
- run docker build, for example "docker build -t wvs_ros2_humble:patch10 ." note: patch10, because the Dockerfile will download the patch10 version of the ROS2 humble distro

## How to build the WVS_ROS2 nuget package
- run the following command from powershell in the repository directory
- docker run -it -v ${PWD}:C:\host wvs_ros2_humble:patch10 C:\host\compile.ps1
- This docker image will create a .nuget package that can be used to build plugins for the WVS simulator
