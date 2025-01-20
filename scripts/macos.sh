#!/bin/zsh

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory of the script
script_path=$(realpath "$0")

echo -e "${YELLOW}Checking if the script is run as root...${NC}"
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Do not run as root. Exiting.${NC}"
    exit 1
fi

echo -e "${YELLOW}Checking Homebrew installation...${NC}"
if command -v brew &>/dev/null; then
    echo -e "${GREEN}Homebrew is installed.${NC}"
else
    echo -e "${RED}Homebrew is not installed. Exiting.${NC}"
    exit 1
fi

# RISCV-tools
echo -e "${YELLOW}Installing RISCV-tools...${NC}"
brew tap riscv-software-src/riscv
brew install riscv-tools

echo -e "${YELLOW}Installing GDB...${NC}"
brew install riscv64-elf-gdb
ln -s /opt/homebrew/bin/riscv64-elf-gdb /opt/homebrew/bin/riscv64-unknown-elf-gdb

# QEMU
echo -e "${YELLOW}Cloning QEMU...${NC}"
git clone https://git.qemu.org/git/qemu.git $HOME/qemu_temp --branch=v9.0.2 --depth 1

echo -e "${YELLOW}Applying QEMU patch...${NC}"
cd $HOME/qemu_temp
patch -p0 < $script_path/../resources/qemu.patch

echo -e "${YELLOW}Configuring and building QEMU...${NC}"
./configure --target-list=riscv64-softmmu --enable-sdl --enable-gtk --enable-vnc --enable-cocoa --enable-system --disable-werror
make
sudo make install

# Clean up
echo -e "${YELLOW}Cleaning up temporary files...${NC}"
rm -rf $HOME/qemu_temp

echo -e "${GREEN}Installation complete!${NC}"