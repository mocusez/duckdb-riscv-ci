FROM debian:sid

# Install dependencies
RUN apt-get update && apt-get install -y \
    qemu-system \
    u-boot-qemu \
    openssh-server \
    screen \
    sshpass \
    opensbi \
    wget \
    unzip \
    cmake \
    ninja-build \
    libssl-dev \
    g++-riscv64-linux-gnu


# Create working directory
WORKDIR /riscv-env

# Download and extract Debian image
RUN wget -O debian.zip https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt && \
    unzip debian.zip

# Create startup script
RUN echo '#!/bin/bash\n\
screen -dmS qemu qemu-system-riscv64 \\\n\
  -machine virt \\\n\
  -cpu rv64,zba=true,zbb=true,v=true,vlen=256,vext_spec=v1.0,rvv_ta_all_1s=true,rvv_ma_all_1s=true \\\n\
  -smp 4 \\\n\
  -m 4G \\\n\
  -device virtio-blk-device,drive=hd \\\n\
  -drive file=dqib_riscv64-virt/image.qcow2,if=none,id=hd \\\n\
  -device virtio-net-device,netdev=net \\\n\
  -netdev user,id=net,hostfwd=tcp::2222-:22 \\\n\
  -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \\\n\
  -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \\\n\
  -append "root=LABEL=rootfs console=ttyS0" \\\n\
  -nographic' > /riscv-env/start-qemu.sh && \
  chmod +x /riscv-env/start-qemu.sh

# Set the entrypoint to the startup script
ENTRYPOINT ["/riscv-env/start-qemu.sh"]

# Expose SSH port
EXPOSE 2222