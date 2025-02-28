FROM debian:sid

# Install dependencies
RUN apt-get update && apt-get install -y \
    qemu-system-riscv \
    u-boot-qemu \
    openssh-server \
    screen \
    sshpass \
    wget \
    unzip \
    cmake \
    ninja-build \
    libssl-dev \
    g++-riscv64-linux-gnu

# Download and extract Debian image
RUN wget -O debian.zip https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt && \
    unzip debian.zip

# Copy startup script
COPY --chmod=755 start_qemu.sh start_qemu.sh

# Set the entrypoint to the startup script
ENTRYPOINT ["/bin/bash"]

# Expose SSH port
EXPOSE 2222