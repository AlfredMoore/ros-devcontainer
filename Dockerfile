
FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Detroit

# Install commonly-used development tools.
RUN apt-get update && apt-get install --yes \
    build-essential \
    clang-12 \
    clang-format-12 \
    cmake \
    g++ \
    gdb \
    git \
    nano \
    valgrind \
    vim

# Remap clang-12 and clang-format-12 to clang and clang-format, respectively.
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 100
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-12 100

# Install commonly-used Python tools.
RUN apt-get update && apt-get install --yes \
    python-is-python3 \
    python3-catkin-tools \
    python3-pip
RUN pip3 install --upgrade virtualenv

# Install commonly-used command-line tools.
RUN apt-get update && apt-get install --yes \
    curl \
    iputils-ping \
    less \
    mesa-utils \
    net-tools \
    rsync \
    software-properties-common \
    tmux \
    tree \
    unzip \
    usbutils \
    wget \
    zip \
    zsh
