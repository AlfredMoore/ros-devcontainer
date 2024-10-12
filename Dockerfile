
FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Install commonly-used development tools.
RUN apt-get update && apt-get install --yes \
    build-essential \
    # clang-12 \
    # clang-format-12 \
    cmake \
    g++ \
    gdb \
    git \
    nano \
    valgrind \
    vim

# Remap clang-12 and clang-format-12 to clang and clang-format, respectively.
# RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 100
# RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-12 100

# Install commonly-used Python tools.
RUN apt-get update && apt-get install --yes \
    python-is-python3 \
    python3-catkin-tools \
    python3-pip
RUN pip3 install --upgrade virtualenv

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
    usbutils \
    wget \
    zip \
    zsh

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

# RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local/pypoetry python3.10 -
# RUN ln -s /usr/local/pypoetry/bin/* /usr/local/bin/

RUN apt-get update && apt-get install ros-noetic-libfranka ros-noetic-franka-ros

# Install Rust and Cargo
ENV RUSTUP_HOME=/opt/rust
ENV CARGO_HOME=/opt/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$CARGO_HOME/bin:${PATH}"


# # Set up realtime kernel, run this outside the docker!!!
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

# with realtime kernel, set up realtime user group
RUN addgroup realtime
RUN usermod -a -G realtime $(whoami)
RUN echo "@realtime soft rtprio 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime soft priority 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime soft memlock 102400" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard rtprio 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard priority 99" | tee -a /etc/security/limits.conf
RUN echo "@realtime hard memlock 102400" | tee -a /etc/security/limits.conf