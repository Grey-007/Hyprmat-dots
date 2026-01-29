#!/bin/bash

set -e

echo "🌌 HyprMat Arch Installer"
echo "========================="

# Ensure Arch Linux
if ! command -v pacman >/dev/null 2>&1; then
    echo "❌ This script is for Arch Linux only."
    exit 1
fi

echo "📦 Installing HyprMat core dependencies..."

sudo pacman -S --needed \
    # ========================
    # Hyprland core
    # ========================
    hyprland \
    hypridle \
    hyprlock \
    hyprpaper \
    xdg-desktop-portal-hyprland \
    wayland \
    wl-clipboard \
    grim \
    slurp \
    swappy \
    pipewire \
    wireplumber \
    polkit-gnome \
    qt5-wayland \
    qt6-wayland \
    seat \
    mesa \
    vulkan-intel \
    vulkan-radeon \
    libinput \

    # ========================
    # Theme engine (HyprMat)
    # ========================
    imagemagick \
    jq \
    bc \
    git \
    curl \
    unzip \

    # ========================
    # UI apps
    # ========================
    kitty \
    rofi-wayland \
    dunst \
    swww \
    waybar\

    # ========================
    # GTK stack + File Manager
    # ========================
    gtk3 \
    gtk4 \
    nautilus \
    gvfs \
    gvfs-mtp \
    gvfs-smb \
    gnome-keyring \
    xdg-user-dirs \

    # ========================
    # Fonts (important)
    # ========================
    ttf-dejavu \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \

    # ========================
    # System utilities (recommended)
    # ========================
    networkmanager \
    bluez \
    bluez-utils \
    brightnessctl \
    playerctl \
    pamixer \
    power-profiles-daemon

echo ""
echo "🎨 Installing Matugen..."

if ! command -v matugen >/dev/null 2>&1; then
    if command -v cargo >/dev/null 2>&1; then
        cargo install matugen
    else
        echo "⚠️ Rust not found. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source "$HOME/.cargo/env"
        cargo install matugen
    fi
else
    echo "✔ Matugen already installed"
fi

echo ""
echo "⚙️ Enabling essential services..."

sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable power-profiles-daemon.service

echo ""
echo "📁 Creating user directories..."
xdg-user-dirs-update

echo ""
echo "✅ HyprMat + GTK + File Manager installed successfully!"
echo ""
echo "Next steps:"
echo "1) Clone HyprMat repo"
echo "2) Run: ./bin/hyprmat <wallpaper>"
echo "3) Restart Hyprland"
