#!/bin/bash

set -e

echo "🌌 HyprMat Arch Installer (AUR + Matugen)"
echo "======================================="

# Check Arch Linux
if ! command -v pacman >/dev/null 2>&1; then
    echo "❌ This script is for Arch Linux only."
    exit 1
fi

# ------------------------
# Install base-devel (needed for AUR)
# ------------------------
echo "🔧 Installing build tools..."
sudo pacman -S --needed base-devel git

# ------------------------
# Install AUR helper (yay or paru)
# ------------------------

install_yay() {
    echo "📦 Installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
}

install_paru() {
    echo "📦 Installing paru (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
}

if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
    echo "✔ yay found"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
    echo "✔ paru found"
else
    echo "⚠️ No AUR helper found."
    echo "Choose one:"
    echo "1) yay (recommended)"
    echo "2) paru"
    read -p "Enter choice [1/2]: " choice
    if [ "$choice" = "2" ]; then
        install_paru
        AUR_HELPER="paru"
    else
        install_yay
        AUR_HELPER="yay"
    fi
fi

# ------------------------
# Install HyprMat packages
# ------------------------

echo "📦 Installing HyprMat dependencies..."

PKGS=(
    # Hyprland core
    hyprland
    hypridle
    hyprlock
    hyprpaper
    xdg-desktop-portal-hyprland
    wayland
    wl-clipboard
    grim
    slurp
    swappy
    pipewire
    wireplumber
    polkit-gnome
    qt5-wayland
    qt6-wayland
    mesa
    libinput

    # UI apps
    kitty
    rofi-wayland
    dunst
    swww

    # GTK + File manager
    gtk3
    gtk4
    nautilus
    gvfs
    gvfs-mtp
    gvfs-smb
    gnome-keyring
    xdg-user-dirs

    # Fonts
    ttf-dejavu
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk

    # Utilities
    imagemagick
    jq
    bc
    curl
    unzip
    networkmanager
    bluez
    bluez-utils
    brightnessctl
    playerctl
    pamixer
    power-profiles-daemon
)

sudo pacman -S --needed "${PKGS[@]}"

# ------------------------
# Install Matugen from AUR
# ------------------------

echo "🎨 Installing Matugen from AUR..."

$AUR_HELPER -S --needed matugen

# ------------------------
# Enable services
# ------------------------

echo "⚙️ Enabling system services..."

sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable power-profiles-daemon.service

# ------------------------
# Setup user directories
# ------------------------

echo "📁 Creating user directories..."
xdg-user-dirs-update

echo ""
echo "✅ HyprMat + AUR + Matugen installed successfully!"
echo ""
echo "Next steps:"
echo "1) Clone HyprMat repo"
echo "2) Run: ./bin/hyprmat <wallpaper>"
echo "3) Restart Hyprland"
