
FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Install commonly-used development tools.
RUN apt-get update && apt-get install --yes \
    build-essential \
    cmake \
    g++ \
    gdb \
    git \
    nano \
    valgrind \
    vim

# Install commonly-used command-line tools.
RUN apt-get update && apt-get install --yes \
    curl \
    iproute2 \
    iputils-ping \
    less \
    mesa-utils \
    net-tools \
    rsync \
    software-properties-common \
    tmux \
    tree \
    unzip \
    zip \
    usbutils \
    wget \
    zsh

# Install Python and Python tools
RUN apt-get update && apt-get install --yes \
    python-is-python3 \
    python3-catkin-tools \
    python3-pip
RUN pip3 install --upgrade virtualenv
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --yes \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3.9-venv \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-venv

# Install libfranka and franka-ros
RUN apt-get update && apt-get install --yes\
    ros-noetic-libfranka \
    ros-noetic-franka-ros

# Install Rust and Cargo
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$CARGO_HOME/bin:${PATH}"
# RUN chown -R $(whoami):$(whoami) $CARGO_HOME

# Install ranged-IK dependencies
RUN pip3 install \
    readchar \
    PyYaml \
    urdf-parser-py \
    future

####################################################################################
##- Set up REALTIME KERNEL, run these outside the docker!!!
####################################################################################
# sudo apt-get install --yes \
#     build-essential bc curl ca-certificates gnupg2 libssl-dev lsb-release libelf-dev bison flex dwarves zstd libncurses-dev

# sudo apt-get install --yes \
#     flex bison libncurses-dev debhelper

# # vim linux-*/.config and change 

# curl -SLO https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.8.2.tar.xz
# curl -SLO https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.8.2.tar.sign
# curl -SLO https://www.kernel.org/pub/linux/kernel/projects/rt/6.8/patch-6.8.2-rt11.patch.xz
# curl -SLO https://www.kernel.org/pub/linux/kernel/projects/rt/6.8/patch-6.8.2-rt11.patch.sign
# # follow the instruction https://frankaemika.github.io/docs/installation_linux.html#setting-up-the-real-time-kernel
####################################################################################

# with realtime kernel, set up realtime user group
RUN addgroup realtime
RUN usermod -a -G realtime $(whoami)
RUN echo "@realtime soft rtprio 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime soft priority 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime soft memlock 102400" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard rtprio 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard priority 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard memlock 102400" | tee -a /etc/security/limits.conf