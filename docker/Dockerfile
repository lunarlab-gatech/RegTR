FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

# System dependencies for MinkowskiEngine, PyTorch3D, open3d, and general use
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libopenblas-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ninja-build \
    python3.8 \
    python3.8-dev \
    python3-pip \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Make python3.8 the default python/python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install PyTorch 2.0.1 + torchvision 0.15.2 (CUDA 11.8)
RUN pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 \
    -f https://download.pytorch.org/whl/torch_stable.html

# GPU architecture passed in from build_image.sh (e.g. "7.5" for Titan RTX)
ARG CUDA_ARCH
ENV TORCH_CUDA_ARCH_LIST=${CUDA_ARCH}

# Install PyTorch3D 0.7.4 (FORCE_CUDA=1 required since no GPU is available at build time)
RUN FORCE_CUDA=1 pip install "git+https://github.com/facebookresearch/pytorch3d.git@v0.7.4"


# Set user arguments (being username, echo $UID, and id -g)
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Create a non-root user with matching UID/GID
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add a custom .bashrc with warm colors and fixed hostname
RUN echo 'export PS1="\\[\\e[1;31m\\]\\u@regtr_container\\[\\e[0m\\]:\\[\\e[1;33m\\]\\w\\[\\e[0m\\]\\$ "' > /home/${USERNAME}/.bashrc && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc

# Set default user & shell
USER ${USERNAME}
WORKDIR /home/${USERNAME}
SHELL ["/bin/bash", "-c"]
RUN echo "export USER=${USERNAME}" >> ~/.bashrc