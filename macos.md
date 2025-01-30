# ECE391 on MacOS

The course materials do not officially support MacOS.
In [mp0](https://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/mp0_fa24.pdf),
it writes "For Mac OS:
The native setup for Mac OS has demonstrated issues affecting the setup process. If you would like to work
remotely with Mac OS, it is recommended to either use FastX or SSH X-forwarding."

However, setting up a native environment on macOS is actually **straightforward** with the right steps.

This configuration is tested on MacOS Sequoia 15.2.
Earlier MacOS versions may probably work as well, but not guaranteed.

Ensure you have [Homebrew](https://brew.sh) installed before proceeding.

You can either run my [installation script](./scripts/macos.sh) or follow the manual steps.

## Installation Script

Run the following commands to set up the environment automatically:

```sh
git clone https://github.com/Yao-Xinchen/ECE391-Workflow
cd ECE391-Workflow
chmod +x ./scripts/macos.sh
./scripts/macos.sh
```

## Manual Installation

### RISC-V Toolchain

Install the toolchain with:

```sh
brew tap riscv-software-src/riscv
brew install riscv-tools
```

This installs the following binaries in `/opt/homebrew/bin/`:

```text
riscv64-unknown-elf-addr2line   riscv64-unknown-elf-gcc-ar      riscv64-unknown-elf-nm        
riscv64-unknown-elf-ar          riscv64-unknown-elf-gcc-nm      riscv64-unknown-elf-objcopy   
riscv64-unknown-elf-as          riscv64-unknown-elf-gcc-ranlib  riscv64-unknown-elf-objdump   
riscv64-unknown-elf-c++         riscv64-unknown-elf-gcov        riscv64-unknown-elf-ranlib    
riscv64-unknown-elf-c++filt     riscv64-unknown-elf-gcov-dump   riscv64-unknown-elf-readelf   
riscv64-unknown-elf-cpp         riscv64-unknown-elf-gcov-tool   riscv64-unknown-elf-size      
riscv64-unknown-elf-elfedit     riscv64-unknown-elf-gprof       riscv64-unknown-elf-strings   
riscv64-unknown-elf-g++         riscv64-unknown-elf-ld          riscv64-unknown-elf-strip     
riscv64-unknown-elf-gcc         riscv64-unknown-elf-ld.bfd                                    
riscv64-unknown-elf-gcc-13.2.0  riscv64-unknown-elf-lto-dump
```

To verify the installation, run:

```sh
which riscv64-unknown-elf-gcc
```

Replace `riscv64-unknown-elf-gcc` with any of the installed binaries to test others.

#### GDB

The toolchain package does not include **GDB**. To install GDB, run:

```sh
brew install riscv64-elf-gdb
```

This installs riscv64-elf-gdb in `/opt/homebrew/bin/`.
Link it to match the expected name:

```sh
ln -s /opt/homebrew/bin/riscv64-elf-gdb /opt/homebrew/bin/riscv64-unknown-elf-gdb
```

### QEMU

The version of QEMU installed via Homebrew (`brew install qemu`)
will encounter issues when running the provided `cp1-gold.elf` kernel due to peripheral conflicts.

To avoid this problem, we need to compile the QEMU from source with the provided patch.

Clone the source code with

```sh
git clone https://git.qemu.org/git/qemu.git --branch=v9.0.2
```

Download the patch
- From [the ECE391 official](http://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/qemu.patch)
- Or from [my backup](./resources/qemu.patch)

**These patches are for FA2024.
If you are in a different semester, please download the corresponding patch from the course website.**

Apply the patch for RISC-V:
Replace `/path/to/your/qemu.patch` with the path to the [patch file](./resources/qemu.patch).
```sh
cd qemu
patch -p0 < /path/to/your/qemu.patch
```

Compile and install the QEMU:

```sh
./configure --target-list=riscv64-softmmu --enable-sdl --enable-gtk --enable-vnc --enable-cocoa --enable-system --disable-werror
make
sudo make install
```

Verify the installation:

```sh
which qemu-system-riscv64
```

### Clangd (Optional)

To enable code completion and syntax checking with **Clangd**,
create a `.clangd` configuration file in your project root.

Here’s an example:

```
CompileFlags:
  Add: [
    -xc,
    --gcc-toolchain=/opt/homebrew/bin/riscv64-unknown-elf-gcc,
    -I/opt/homebrew/Cellar/riscv-gnu-toolchain/main/lib/gcc/riscv64-unknown-elf/13.2.0/include,
    --target=riscv64-unknown-elf,
  ]
```

Refer to the [VS Code setup guide](./vscode.md) for additional details.

## MP1

To enable graphic output in MP1, you need to add `-display sdl` to Makefile.

```makefile
run-demo:
	$(QEMU) -machine virt -bios none -kernel demo.elf -m 128M -serial mon:stdio -device bochs-display -display sdl
```
