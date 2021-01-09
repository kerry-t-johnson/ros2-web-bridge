ARG FROM_IMAGE=ros:foxy-ros-base-focal
FROM $FROM_IMAGE

ENV RMW_IMPLEMENTATION="rmw_cyclonedds_cpp"
ENV ROS2_WEB_BRIDGE_VERSION=0.3.0

RUN apt-get update                                                        &&  \
    apt-get install -y  ros-${ROS_DISTRO}-rmw-cyclonedds-cpp                  \
                        curl                                              &&  \
    curl  --silent                                                            \
          --location                                                          \
          --output /tmp/nodesource_setup.sh                                   \
            https://deb.nodesource.com/setup_12.x                         &&  \
    /bin/bash /tmp/nodesource_setup.sh                                    &&  \
    apt-get install -y  nodejs                                            &&  \
    cd /opt                                                               &&  \
    git clone https://github.com/RobotWebTools/ros2-web-bridge.git        &&  \
    cd  ros2-web-bridge                                                   &&  \
    git checkout -b release-${ROS2_WEB_BRIDGE_VERSION} ${ROS2_WEB_BRIDGE_VERSION}

WORKDIR /opt/ros2-web-bridge

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/$ROS_DISTRO/setup.bash  &&  \
    npm install

CMD ["node", "bin/rosbridge.js"]
