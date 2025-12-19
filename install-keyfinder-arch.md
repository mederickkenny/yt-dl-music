# Installation Steps for Arch/CachyOS

## Option 1: Using an AUR Helper (Easiest - Recommended)
If you have yay or paru installed:
```bash
# Install keyfinder-cli (this will also install libkeyfinder as a dependency)
yay -S keyfinder-cli

# Or using paru
paru -S keyfinder-cli
```

## Option 2: Manual Installation from AUR
If you don't have an AUR helper:

``` bash
# Install libkeyfinder from official repos (dependency)
sudo pacman -S libkeyfinder fftw ffmpeg

# Clone the keyfinder-cli AUR package
git clone https://aur.archlinux.org/keyfinder-cli.git
cd keyfinder-cli

# Build and install
makepkg -si
```

The `-si` flags mean:

`-s`: Install dependencies automatically
`-i`: Install the package after building

Verify Installation
```bash
keyfinder-cli --version
```
Why This is Easier on Arch

- libkeyfinder is in the official repos - No need to build from source!
- The AUR package is actively maintained - Version 1.1.4-2, last updated November 2025
- All dependencies are available - ffmpeg, fftw, cmake all in official repos

# Note on CachyOS
CachyOS uses the same package system as Arch, so these instructions work identically. CachyOS also comes with paru pre-installed in most cases, making AUR installation even easier.