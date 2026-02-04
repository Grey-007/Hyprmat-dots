#!/usr/bin/env bash
set -euo pipefail

echo "🌌 Hyprland Required Dependencies Installer"
echo "========================================="

# ------------------------
# Arch Linux check
# ------------------------

if ! command -v pacman >/dev/null 2>&1; then
  echo "❌ This script is for Arch Linux only."
  exit 1
fi

# ------------------------
# Base tools
# ------------------------

echo "🔧 Installing build tools..."
sudo pacman -S --needed --noconfirm base-devel git wget curl

# ------------------------
# AUR helpers
# ------------------------

install_yay() {
  echo "📦 Installing yay..."
  cd /tmp || exit 1
  rm -rf yay
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit 1
  makepkg -si --noconfirm
}

install_paru() {
  echo "📦 Installing paru..."
  cd /tmp || exit 1
  rm -rf paru
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit 1
  makepkg -si --noconfirm
}

if command -v yay >/dev/null 2>&1; then
  AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
  AUR_HELPER="paru"
else
  echo "⚠️ No AUR helper found"
  echo "1) yay (recommended)"
  echo "2) paru"
  read -rp "Choose [1/2]: " choice

  if [[ "$choice" == "2" ]]; then
    install_paru
    AUR_HELPER="paru"
  else
    install_yay
    AUR_HELPER="yay"
  fi
fi

# ------------------------
# Core packages
# ------------------------

PKGS=(
  hypridle
  hyprlock
  xdg-desktop-portal-hyprland
  wayland
  wl-clipboard
  libinput
  mesa

  pipewire
  pipewire-pulse
  wireplumber
  playerctl
  pamixer
  pavucontrol

  polkit-gnome
  networkmanager
  bluez
  bluez-utils
  blueman
  brightnessctl
  power-profiles-daemon

  kitty
  swaync
  cava
  nwg-look
  swww

  nautilus
  gvfs
  gvfs-mtp
  gvfs-smb
  gnome-keyring
  xdg-user-dirs
  adwaita-icon-theme
  gnome-themes-extra

  imagemagick
  jq
  bc
  unzip
)

echo "📦 Installing core packages..."
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

# ------------------------
# Fonts
# ------------------------

FONTS=(
  ttf-dejavu
  noto-fonts
  noto-fonts-emoji
  noto-fonts-cjk
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  ttf-fira-code
  ttf-firacode-nerd
  ttf-nerd-fonts-symbols
)

echo "🔤 Installing fonts..."
sudo pacman -S --needed --noconfirm "${FONTS[@]}"

# ------------------------
# Rofi pinned version
# ------------------------

echo "🎯 Installing Rofi 1.7.5..."
cd /tmp || exit 1
wget https://archive.archlinux.org/packages/r/rofi/rofi-1.7.5-1-x86_64.pkg.tar.zst
sudo pacman -U --noconfirm rofi-1.7.5-1-x86_64.pkg.tar.zst

# ------------------------
# AUR packages
# ------------------------

echo "🎨 Installing AUR packages..."
"$AUR_HELPER" -S --needed --noconfirm \
  matugen \

# ------------------------
# Services
# ------------------------

echo "⚙️ Enabling services..."
sudo systemctl enable NetworkManager bluetooth power-profiles-daemon

# ------------------------
# User dirs
# ------------------------

echo "📁 Creating user directories..."
xdg-user-dirs-update

echo "✅ Done. System is ready for Hyprland."
