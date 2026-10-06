#!/bin/bash

# Define paths
WORKSPACE_DIR="$HOME/pico-workspace"
SDK_DIR="$WORKSPACE_DIR/pico-sdk"
BASHRC_FILE="$HOME/.bashrc"
EXPORT_LINE="export PICO_SDK_PATH=\"$SDK_DIR\""

echo "Starting Raspberry Pi Pico SDK setup..."

# 1. Create workspace directory
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR" || { echo "Failed to navigate to $WORKSPACE_DIR"; exit 1; }

# 2. Clone or update the SDK repository
if [ -d "$SDK_DIR" ]; then
    echo "Pico SDK already exists in $SDK_DIR."
    echo "Pulling latest changes..."
    cd "$SDK_DIR" || exit 1
    git pull
else
    echo "Cloning Pico SDK into $SDK_DIR..."
    git clone https://github.com/raspberrypi/pico-sdk.git
    cd "$SDK_DIR" || exit 1
fi

# 3. Initialize and update submodules (crucial for TinyUSB, lwIP, etc.)
echo "Updating git submodules..."
git submodule update --init

# 4. Add the SDK path to .bashrc for persistence
if grep -qF "$EXPORT_LINE" "$BASHRC_FILE"; then
    echo "PICO_SDK_PATH is already configured in $BASHRC_FILE."
else
    echo "Adding PICO_SDK_PATH to $BASHRC_FILE..."
    echo -e "\n# Raspberry Pi Pico SDK" >> "$BASHRC_FILE"
    echo "$EXPORT_LINE" >> "$BASHRC_FILE"
fi

echo "Setup code extensions..."

code --install-extension cantonios.project-templates
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
# code --install-extension fleexo.cpp-class-creator
code --install-extension amiralizadeh9480.cpp-helper
# code --install-extension platformio.platformio-ide
#code --install-extension dnut.rewrap-revived
#code --install-extension mhutchie.git-graph
#code --install-extension jebbs.plantuml
#code --install-extension wavetrace.wavetrace
code --install-extension raspberry-pi.raspberry-pi-pico
code --install-extension ms-vscode.vscode-serial-monitor



echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo "To apply the environment variables to your current session, run:"
echo "  source ~/.bashrc"

