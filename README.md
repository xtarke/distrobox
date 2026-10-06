# Fedora 41 Pico SDK Distrobox Environment

This guide explains how to create and use an automated Distrobox container running Fedora 41, pre-configured with Visual Studio Code and the Raspberry Pi Pico SDK cross-compilation toolchain.

## 1. Setup the `distrobox.ini` Manifest

Create a file named `distrobox-rp-pico.ini` and paste the following configuration. This file will handle installing all dependencies, adding the VS Code repository, and automatically cloning the Pico SDK into your workspace.

```ini
[fedora-pico-dev]
image=registry.fedoraproject.org/fedora:41

# Add the Microsoft GPG key and the VS Code repository
pre_init_hooks="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo sh -c 'echo -e \"[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" > /etc/yum.repos.d/vscode.repo'"

# Install VS Code, build systems, and the ARM cross-compilation toolchain
additional_packages="code git cmake make gcc gcc-c++ doxygen arm-none-eabi-gcc-cs arm-none-eabi-gcc-cs-c++ arm-none-eabi-binutils arm-none-eabi-newlib"

# Automatically create workspace, clone SDK, update submodules, and set PICO_SDK_PATH
#init_hooks="mkdir -p ~/pico-workspace && cd ~/pico-workspace && if [ ! -d pico-sdk ]; then git clone https://github.com/raspberrypi/pico-sdk.git; fi && cd pico-sdk && git submodule update --init && if ! grep -qF 'export PICO_SDK_PATH' ~/.bashrc; then echo -e '\n# Raspberry Pi Pico SDK\nexport PICO_SDK_PATH=\"$HOME/pico-workspace/pico-sdk\"' >> ~/.bashrc; fi"

init_hooks="sudo dnf update -y"

# Container configurations
pull=true
replace=true
```

## 2. Build the Container

Run the following command in the same directory as your `distrobox-rp-pico.ini` file to assemble the container:

```bash
distrobox assemble create --file distrobox.ini --home <path_to_isolated_home>
```

```
distrobox create --image registry.fedoraproject.org/fedora-toolbox:41 --name fedora-toolbox-41 --home /home/xtarke/Data/Apps/rp-pico-home
```

*Note: This may take a few minutes as it pulls the Fedora 41 image, installs VS Code, sets up the ARM GCC toolchains, and clones the Pico SDK.*

## 3. Enter the Container

Once the build is complete, you can enter the environment using:

```bash
distrobox enter fedora-pico-dev
```

When you enter, the `PICO_SDK_PATH` will already be configured in your environment. You can verify this by running:
```bash
echo $PICO_SDK_PATH
```

## 4. Export VS Code to Host (Optional)

If you prefer to launch Visual Studio Code from your host OS application launcher (but have it run seamlessly inside the container), run this command **while inside the container**:

```bash
distrobox-export --app code
```
