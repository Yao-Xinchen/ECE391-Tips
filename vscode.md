# VS Code

This is a demo for how to set up a RISC-V development environment in VS Code.

## Debugging

## Language Server

I use [clangd extension](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd)
for
- syntax checking
- code completion
- finding definitions and usages
- inlay hints

By default, it uses the `gcc` in your PATH to compile the code.
But we want to use the `riscv64-unknown-elf-gcc` instead.
So we need to create a `.clangd` file in the root directory to specify the compiler and headers to use.

We need the following flags:
1. `-xc` to specify the language as C
2. `--gcc-toolchain` to specify the path to the compiler
3. `-I` to specify the path to the headers
4. `--target=riscv-unknown-elf` to specify the target architecture

On my Mac, the `.clangd` file looks like this:
```
CompileFlags:
  Add: [
    -xc,
    --gcc-toolchain=/opt/homebrew/bin/riscv64-unknown-elf-gcc,
    -I/opt/homebrew/Cellar/riscv-gnu-toolchain/main/lib/gcc/riscv64-unknown-elf/13.2.0/include,
    --target=riscv64-unknown-elf,
  ]
```

## Formatting

I use [clang-format](https://marketplace.visualstudio.com/items?itemName=xaver.clang-format)
to format the code.

After installing the extension, change your default formatter to `clang-format` in the settings.

The extension relies on the `clang-format` executable in your PATH.
You can install it with your package manager (e.g. `brew install clang-format` on Mac).

We also need to create a `.clang-format` file in the root directory to specify the formatting style.
You can write your own style based on my [.clang-format](./template/.clang-format).

After that, you are ready to format your code.
You can check your keymaps for the format command in the `Keyboard Shortcuts` settings.
Press `Ctrl+K` then `Ctrl+S` to open the settings and search for `format`.