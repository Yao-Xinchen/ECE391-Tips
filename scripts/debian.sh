#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking if the script is run as root...${NC}"
if [[ "$EUID" -eq 0 ]]; then
    echo -e "${RED}Do not run as root. Exiting.${NC}"
    exit 1
fi

# RISCV-tools
echo -e "${YELLOW}Installing RISCV prerequisites...${NC}"
sudo apt update
sudo apt install -y autoconf automake autotools-dev curl python3 \
python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev \
libpixman-1-dev libgtk-3-dev

echo -e "${YELLOW}Creating /opt/riscv directory...${NC}"
sudo mkdir -p /opt/riscv
sudo chmod -R a+rwx /opt/riscv

echo -e "${YELLOW}Cloning RISCV GNU Toolchain...${NC}"
git clone --branch 2024.04.12 https://github.com/riscv/riscv-gnu-toolchain $HOME/riscv-gnu-toolchain_temp

echo -e "${YELLOW}Configuring and building RISCV GNU Toolchain...${NC}"
cd $HOME/riscv-gnu-toolchain_temp
./configure --prefix=/opt/riscv --enable-multilib

echo -e "${YELLOW}Building RISCV GNU Toolchain...${NC}"
make

echo -e "${YELLOW}Creating /opt/qemu directory...${NC}"
sudo mkdir -p /opt/qemu
sudo chmod -R a+rwx /opt/qemu

echo -e "${YELLOW}Cloning QEMU...${NC}"
git clone https://git.qemu.org/git/qemu.git $HOME/qemu_temp --branch=v9.0.2 --depth 1

echo -e "${YELLOW}Applying QEMU patch...${NC}"
patch -d $HOME/qemu_temp -p0 <$(dirname "$0")/../resources/qemu.patch

echo -e "${YELLOW}Configuring and building QEMU...${NC}"
cd $HOME/qemu_temp
./configure --prefix=/opt/qemu \
--target-list=riscv32-softmmu,riscv64-softmmu --enable-gtk \
--enable-system --disable-werror
make
make install

echo -e "${YELLOW}Cleaning up temporary files...${NC}"
rm -rf $HOME/riscv-gnu-toolchain_temp
rm -rf $HOME/qemu_temp

echo -e "${YELLOW}Adding /opt/riscv/bin and /opt/qemu/bin to PATH...${NC}"
if command -v zsh &>/dev/null; then
    echo "export PATH=/opt/riscv/bin:/opt/qemu/bin:\$PATH" >> ~/.zshrc
fi
if command -v bash &>/dev/null; then
    echo "export PATH=/opt/riscv/bin:/opt/qemu/bin:\$PATH" >> ~/.bashrc
fi

echo -e "${GREEN}Installation complete!${NC}"
