screen -dmS qemu qemu-system-riscv64 \
    -machine virt \
    -cpu rv64,zba=true,zbb=true,v=true,vlen=256,vext_spec=v1.0,rvv_ta_all_1s=true,rvv_ma_all_1s=true \
    -smp 4 \
    -m 4G \
    -device virtio-blk-device,drive=hd \
    -drive file=dqib_riscv64-virt/image.qcow2,if=none,id=hd \
    -device virtio-net-device,netdev=net \
    -netdev user,id=net,hostfwd=tcp::2222-:22 \
    -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
    -append "root=LABEL=rootfs console=ttyS0" \
    -nographic
sleep 120 # wait for qemu to boot
sshpass -p 'root' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r -P 2222 /duckdb/build/release/duckdb root@localhost:/root 
sshpass -p 'root' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 root@localhost "chmod +x duckdb && ./duckdb -c 'PRAGMA platform;'"