# Detect GPU compute capability from the host (e.g. "7.5" for Titan RTX)
CUDA_ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | head -1)
echo "Detected CUDA arch: ${CUDA_ARCH}"

# CUDA 11.8 supports up to sm_90 (Hopper), so no capping needed for any current consumer GPU.
TORCH_CUDA_ARCH="${CUDA_ARCH}"

docker build --build-arg USERNAME=$(id -un) --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) --build-arg CUDA_ARCH=${TORCH_CUDA_ARCH} -t regtr .