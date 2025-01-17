# ECE391 on MacOS

The course materials do not officially support MacOS.
In [mp0](https://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/mp0_fa24.pdf),
it writes "For Mac OS:
The native setup for Mac OS has demonstrated issues affecting the setup process. If you would like to work
remotely with Mac OS, it is recommended to either use FastX or SSH X-forwarding."

However, it is actually **not hard** to setup a native environment on MacOS.

This configuration is tested on MacOS Sequoia 15.2.
Earlier MacOS versions may probably work as well, but not guaranteed.

Before you start, make sure you have installed [Homebrew](https://brew.sh).

## RISC-V Toolchain

Install the toolchain with

```sh
brew tap riscv-software-src/riscv
brew install riscv-tools
```

Now, you should have these binaries in `/opt/homebrew/bin/`:

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

You can check whether the toolchain is installed correctly by running

```sh
which riscv64-unknown-elf-gcc
```

Replace `riscv64-unknown-elf-gcc` with any of the binaries above to check the installation of other tools.

Now, you are able to compile the project with the Makefile provided in the project root directory.

### GDB

The package mentioned above does not include **GDB**. You can install it with

```sh
brew install riscv64-elf-gdb
```

This installs the GDB binary to `/opt/homebrew/bin/riscv64-elf-gdb`.
Then, you can link it to `/opt/homebrew/bin/riscv64-unknown-elf-gdb` with

```sh
ln -s /opt/homebrew/bin/riscv64-elf-gdb /opt/homebrew/bin/riscv64-unknown-elf-gdb
```

## QEMU

To run your compiled kernel, you still need to install **QEMU**.

It is available in Homebrew with `brew install qemu`.
However, the `qemu-system-riscv64` installed through Homebrew cannot run our kernel properly.
You will later encounter an error like `Store access fault at 0xa00001800` when running the provided `cp1-gold.elf`,
if you use this QEMU.
This is related to a conflict between the definition of peripherals in the virtual machine.

To avoid this problem, we need to compile the QEMU from source with the provided patches.

Clone the source code with

```sh
git clone https://git.qemu.org/git/qemu.git --branch=v9.0.2
```

You can download the patches from [the source official](http://courses.grainger.illinois.edu/ece391/fa2024/secure/assignments/mp/mp0/qemu.patch)
or from [my backup](./resources/qemu.patch).

Then, move the patch to the root directory of the QEMU source code and apply it with

```sh
patch -p1 < qemu.patch
```

Now, you can compile the QEMU with

```sh
./configure --target-list=riscv64-softmmu --enable-sdl --enable-gtk --enable-vnc --enable-cocoa --enable-system --disable-werror
make
sudo make install
```

After that, the `qemu-system-riscv64` is available in `/usr/local/bin/`.

You can check this with

```sh
which qemu-system-riscv64
```

## Clangd (Optional)

If you want to use Clangd for code completion and syntax checking,
you should create a `.clangd` file to specify which compiler and headers to use.

This is my `.clangd`:

```
CompileFlags:
  Add: [
    -xc,
    --gcc-toolchain=/opt/homebrew/bin/riscv64-unknown-elf-gcc,
    -I/opt/homebrew/Cellar/riscv-gnu-toolchain/main/lib/gcc/riscv64-unknown-elf/13.2.0/include,
    --target=riscv64-unknown-elf,
  ]
```

Later, your Clangd should be able to provide code completion and syntax checking.
