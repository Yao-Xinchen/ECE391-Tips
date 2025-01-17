#!/bin/bash

# cannot be run as root
if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root. Exiting."
    exit 1
fi

echo "Installing RISCV-tools..."
sudo apt install autoconf automake autotools-dev curl python3 \
python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev \
libpixman-1-dev libgtk-3-dev
mkdir -p /opt/riscv
sudo chmod -R a+rwx /opt/riscv
git clone --branch 2024.04.12 https://github.com/riscv/riscv-gnu-toolchain $HOME/riscv-gnu-toolchain_temp
cd $HOME/riscv-gnu-toolchain_temp
./configure --prefix=/opt/toolchains/riscv/ --enable-multilib
make
make install

echo "Installing QEMU..."
mkdir -p /opt/qemu
git clone https://git.qemu.org/git/qemu.git $HOME/qemu_temp --branch=v9.0.2 --depth 1
patch -d $HOME/qemu_temp -p0 <../resources/qemu.patch
cd $HOME/qemu_temp
./configure --prefix=/opt/qemu \
--target-list=riscv32-softmmu,riscv64-softmmu --enable-gtk \
--enable-system --disable-werror
make

echo "Cleaning up..."
rm -rf $HOME/riscv-gnu-toolchain_temp
rm -rf $HOME/qemu_temp

# echo "Do you want to add these to your PATH? (y/n)"
