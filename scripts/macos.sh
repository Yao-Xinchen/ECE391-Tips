#!/bin/zsh

# cannot be run as root
if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root. Exiting."
    exit 1
fi

# check homebrew
if command -v brew &>/dev/null; then
    echo "Homebrew is installed."
else
    echo "Homebrew is not installed. Exiting."
    exit 1
fi

echo "Installing RISCV-tools..."
brew tap riscv-software-src/riscv
brew install riscv-tools

echo "Installing GDB..."
brew install riscv64-elf-gdb
ln -s /opt/homebrew/bin/riscv64-elf-gdb /opt/homebrew/bin/riscv64-unknown-elf-gdb

echo "Installign QEMU..."
git clone https://git.qemu.org/git/qemu.git $HOME/qemu_temp --branch=v9.0.2
patch -d $HOME/qemu_temp -p1 <../resources/qemu.patch
cd $HOME/qemu_temp
./configure --target-list=riscv64-softmmu --enable-sdl --enable-gtk --enable-vnc --enable-cocoa --enable-system --disable-werror
make
sudo make install

echo "Cleaning up..."
rm -rf $HOME/qemu_temp

echo "Done."
