# ECE391 Workflow

This repository documents the workflows and tools I explored during
[ECE391 FA2024](https://courses.grainger.illinois.edu/ece391/fa2024/),
focusing on environment setup and tool configuration.
It includes [scripts](./scripts/) and guides for replicating these setups.

Contents:
1. Environment installation
    - [MacOS](./macos.md)
    - [Linux](./linux.md)
2. [VSCode configuration](./vscode.md)
    - Debugging with GUI
    - Language server for code analysis
    - Code formatting

This repository does not include any specific course solutions, assignments, or code
that may lead to academic dishonesty.
The provided information is intended solely to aid in
understanding development tools and optimizing debugging workflows.

## Preview

### Environment Installation

Install the environment with a single script:

https://github.com/user-attachments/assets/fbc44238-8ee3-402e-b526-3b1d18bb129f

### Debugging

Debug with a GUI interface:
1. Set breakpoints in the editor.
2. Run the launch configuration.
3. Use the GUI to step through the code.
3. Inspect variables and registers.

![debug_demo](./resources/debug_demo.gif)

### Language Server

Use the language server for enhanced code analysis:
1. Hover over variables to see their types.
2. See function signatures and documentation.
3. Find references and go to definitions.

![clangd_demo](./resources/clangd_demo.gif)

### Code Formatting

Format your code effortlessly, no matter how messy:

![clang_format_demo](./resources/clang_format_demo.gif)

## Acknowledgments

This repository contains references to materials from the ECE391 course at the University of Illinois Urbana-Champaign. All course materials are the creation of the course staff, and I am grateful for their well-designed resources.

Thanks to
- [Tony Zhang](https://github.com/tz61) for creating debugging scripts.
- [Shurong Wang](https://github.com/shurongwang) for helping with compiling QEMU on MacOS.
