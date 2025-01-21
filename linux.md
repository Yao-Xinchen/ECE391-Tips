# ECE391 on Linux

The [official tutorial](https://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/mp0_fa24.pdf)
places the QEMU source code within the RISC-V toolchain directory (/opt/toolchains/riscv)
and installs both to the same location.
However, QEMU and the RISC-V toolchain are **independent** tools, and combining them can be confusing.
This guide provides a more organized setup with separate installations.

You can either use the provided scripts for [Debian/Ubuntu](./scripts/debian.sh) or [Redhat/Fedora](./scripts/redhat.sh).

Or follow the manual steps below.

## Installation Scripts

Run the following commands to set up the environment automatically:

```sh
git clone https://github.com/Yao-Xinchen/ECE391-Workflow
cd ECE391-Workflow
chmod +x ./scripts/debian.sh
./scripts/debian.sh
```

Or for RedHat/Fedora:

```sh
git clone https://github.com/Yao-Xinchen/ECE391-Workflow
cd ECE391-Workflow
chmod +x ./scripts/redhat.sh
./scripts/redhat.sh
```

## Manual Installation

### Prerequisites

#### For Debian/Ubuntu

Install with:

```sh
sudo apt install -y autoconf automake autotools-dev curl python3 \
python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev \
libpixman-1-dev libgtk-3-dev
```

#### For RedHat/Fedora

Install with:

```sh
sudo yum install autoconf automake python3 libmpc-devel mpfr-devel \
gmp-devel gawk bison flex texinfo patchutils gcc gcc-c++ \
zlib-devel expat-devel libslirp-devel
```

### RISC-V Toolchain

Create installation directory `/opt/riscv` if it does not exist:
```sh
sudo mkdir -p /opt/riscv
```

Clone the source code to a temporary directory:
```sh
git clone --branch 2024.04.12 https://github.com/riscv/riscv-gnu-toolchain ~/riscv-gnu-toolchain_temp
```

Build and install with:
```sh
cd ~/riscv-gnu-toolchain_temp
./configure --prefix=/opt/riscv --enable-multilib
sudo make
```

Clean up the temporary directory after installation:
```sh
sudo rm -rf ~/riscv-gnu-toolchain_temp
```

Now, these binaries are available in `/opt/riscv/bin/`:
```text
riscv64-unknown-elf-addr2line   riscv64-unknown-elf-gcc-nm         riscv64-unknown-elf-nm
riscv64-unknown-elf-ar          riscv64-unknown-elf-gcc-ranlib     riscv64-unknown-elf-objcopy
riscv64-unknown-elf-as          riscv64-unknown-elf-gcov           riscv64-unknown-elf-objdump
riscv64-unknown-elf-c++         riscv64-unknown-elf-gcov-dump      riscv64-unknown-elf-ranlib
riscv64-unknown-elf-c++filt     riscv64-unknown-elf-gcov-tool      riscv64-unknown-elf-readelf
riscv64-unknown-elf-cpp         riscv64-unknown-elf-gdb            riscv64-unknown-elf-run
riscv64-unknown-elf-elfedit     riscv64-unknown-elf-gdb-add-index  riscv64-unknown-elf-size
riscv64-unknown-elf-g++         riscv64-unknown-elf-gprof          riscv64-unknown-elf-strings
riscv64-unknown-elf-gcc         riscv64-unknown-elf-ld             riscv64-unknown-elf-strip
riscv64-unknown-elf-gcc-13.2.0  riscv64-unknown-elf-ld.bfd
riscv64-unknown-elf-gcc-ar      riscv64-unknown-elf-lto-dump
```

### QEMU

Create installation directory `/opt/qemu` if it does not exist:
```sh
sudo mkdir -p /opt/qemu
```

Clone the source code to a temporary directory:
```sh
git clone https://git.qemu.org/git/qemu.git ~/qemu_temp --branch=v9.0.2 --depth 1
```

Download the patch
- From [the ECE391 official](http://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/qemu.patch)
- Or from [my backup](./resources/qemu.patch)

**These patches are for FA2024.
If you are in a different semester, please download the corresponding patch from the course website.**

Apply the patch for RISC-V:
Replace `/path/to/your/qemu.patch` with the path to the [patch file](./resources/qemu.patch).
```sh
cd ~/qemu_temp
patch -p0 < /path/to/your/qemu.patch
```

Build and install with:
```sh
./configure --prefix=/opt/qemu \
--target-list=riscv32-softmmu,riscv64-softmmu --enable-gtk \
--enable-system --disable-werror
make
sudo make install
```

Clean up the temporary directory after installation:
```sh
sudo rm -rf ~/qemu_temp
```

Now, these binaries are available in `/opt/qemu/bin/`:
```text
elf2dmp    qemu-ga   qemu-io      qemu-nbd        qemu-storage-daemon  qemu-system-riscv64
qemu-edid  qemu-img  qemu-keymap  qemu-pr-helper  qemu-system-riscv32
```

### Add to PATH

Add the following lines to your `~/.bashrc` or `~/.zshrc`.
```sh
export PATH=/opt/riscv/bin:/opt/qemu/bin:$PATH
```

Then, run `source ~/.bashrc` or `source ~/.zshrc` to apply the changes.

Verify the installation by running:

```sh
which riscv64-unknown-elf-gcc
```

This should return `/opt/riscv/bin/riscv64-unknown-elf-gcc`.

Replace `riscv64-unknown-elf-gcc` with any of the installed binaries to test others.