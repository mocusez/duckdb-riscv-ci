# DuckDB RISC-V CI

A containerized environment for building and testing [DuckDB](https://github.com/duckdb/duckdb) on RISC-V architecture using QEMU emulation.

## Overview

This project provides the infrastructure to:
1. Set up a RISC-V emulation environment using QEMU
2. Build DuckDB for RISC-V architecture
3. Run tests to verify DuckDB functionality on RISC-V

## Components

- **Docker Container**: Debian-based environment with QEMU(Base on [DQIB](https://people.debian.org/~gio/dqib/)) and RISC-V tools
- **QEMU Script**: Configures and launches a RISC-V virtual machine
- **CI/CD Pipeline**: Automates building and publishing the container image

## Requirements

- Docker
- GitHub account (for using the pre-built container)

## Usage

### Using the pre-built Docker image

```bash
# Pull the image
docker pull ghcr.io/mocusez/duckdb-riscv-ci/duckdb-riscv-ci:latest

# Run the container on DuckDB repo
docker run -i --rm -v $(pwd):/duckdb --workdir /duckdb ghcr.io/mocusez/duckdb-riscv-ci/duckdb-riscv-ci <<< "apt-get install -y cmake ninja-build libssl-dev g++-riscv64-linux-gnu && GEN=ninja CC='riscv64-linux-gnu-gcc -march=rv64gcv_zicsr_zifencei_zihintpause_zvl256b' CXX='riscv64-linux-gnu-g++ -march=rv64gcv_zicsr_zifencei_zihintpause_zvl256b' DUCKDB_PLATFORM=linux_riscv make && cd / && ./start_qemu.sh && cd /duckdb && make clean && echo 'DOCKER TEST RESULT: SUCCESS' || (echo 'DOCKER TEST RESULT: FAILURE' && make clean)" 2>&1
```

### Building locally

```bash
# Clone the repository
git clone https://github.com/mocusez/duckdb-riscv-ci.git
cd duckdb-riscv-ci

# Build the Docker image
docker build -t duckdb-riscv-ci .

# Run the container
docker run -it --rm duckdb-riscv-ci

# Inside container, run the QEMU script
./start_qemu.sh
```

## RISC-V Configuration

The QEMU environment is configured with:
- RV64GCV CPU with Vector extensions (RVV)
- 4GB RAM
- 4 CPU cores
- Network access with port forwarding for SSH

## CI/CD Pipeline

GitHub Actions automatically builds and pushes the Docker image on commits to the main branch. The workflow:

1. Checks out the code
2. Logs in to GitHub Container Registry
3. Builds the Docker image
4. Tags and pushes the image to ghcr.io

