# PSPi 6 Community OS Images

Community-built operating system images for the PSPi 6 handheld device.

## 🎯 About This Repository

This repository contains **community-developed OS images** specifically built for the PSPi 6 device. These images are created and maintained independently by community members to provide additional options and customizations for PSPi 6 users.

> **Note**: This is not the official PSPi 6 repository. For official hardware information, drivers, and documentation, visit [othermod's PSPi-Version-6 repository](https://github.com/othermod/PSPi-Version-6).

## 🔄 Development & Build Process

OS images are built using automated pipelines on Azure DevOps, split across two specialized repositories:

- **[pspi-v6-driver-build](https://dev.azure.com/CoryManson/PSPi/_git/pspi-v6-driver-build)**: Driver compilation and hardware interface development
- **[pspi-v6-os-build](https://dev.azure.com/CoryManson/PSPi/_git/pspi-v6-os-build)**: OS image creation, customization, and distribution packaging

This GitHub repository serves as the distribution point for the final, tested images.

## 💿 Available OS Images

Check the [**Releases**](https://github.com/CoryManson/PSPi-Version-6/releases) section for:

- 🎮 **RetroPie** - Optimized for retro gaming with PSPi 6 drivers pre-installed
- 🎯 **Lakka** - Lightweight RetroArch-based gaming OS
- 🛡️ **Kali Linux** - Security-focused distribution for PSPi 6
- 🐧 **Raspberry Pi OS** - Full desktop experience with PSPi 6 support
- � **Batocera** - Gaming-focused OS with extensive emulation support
- 🕹️ **Recalbox** - User-friendly retro gaming distribution
- 📦 **Custom builds** - Specialized images with unique configurations

Each image includes:
- Pre-configured PSPi 6 drivers
- Optimized settings for the hardware
- Community-contributed enhancements
- Detailed installation instructions

## � Quick Start

1. **Download** the latest image from [Releases](https://github.com/CoryManson/PSPi-Version-6/releases)
2. **Flash** the image to a microSD card using tools like Raspberry Pi Imager or Balena Etcher
3. **Insert** the SD card into your PSPi 6 device
4. **Boot** and enjoy!

## 📋 Requirements

- PSPi 6 device (see [official compatibility guide](https://github.com/othermod/PSPi-Version-6/wiki/2.-PSP-Compatibility))
- Compatible Raspberry Pi (Zero, Zero 2W, or CM4)
- microSD card (16GB+ recommended)
- PSPi 6 drivers (pre-installed in these images)

## 🔧 Image Features

All community images include:

- ✅ PSPi 6 drivers pre-installed and configured
- ✅ Optimized performance settings
- ✅ Power management configured
- ✅ Display and audio properly mapped
- ✅ Control input fully functional
- ✅ Battery monitoring enabled

## 🐛 Support & Issues

### For OS Image Issues:
- Create an issue in this repository for problems specific to these community images
- Include your PSPi 6 model, Raspberry Pi version, and detailed error description

### For Hardware/Driver Issues:
- Visit the [official PSPi 6 repository](https://github.com/othermod/PSPi-Version-6)
- Check the [official troubleshooting guide](https://github.com/othermod/PSPi-Version-6/wiki/Troubleshooting)

### For General Support:
- Join the [PSPi Discord community](https://discord.gg/V96c3JC)

## 🤝 Contributing

Contributions to improve these community images are welcome! You can help by:

- Testing images and reporting bugs
- Suggesting optimizations or new features
- Contributing to build scripts and automation
- Creating documentation and guides
- Sharing your custom configurations

## 📖 Documentation

- [Official PSPi 6 Wiki](https://github.com/othermod/PSPi-Version-6/wiki) - Complete hardware and setup guide
- [Features Overview](https://github.com/othermod/PSPi-Version-6/wiki/1.-Features) - What PSPi 6 can do
- [Installation Guide](https://github.com/othermod/PSPi-Version-6/wiki/5.-Board-Installation) - Hardware assembly
- [OS Setup Guide](https://github.com/othermod/PSPi-Version-6/wiki/6.-Operating-Systems) - Software configuration

## ⚖️ License & Credits

- These community OS images are built upon open-source operating systems and PSPi 6 drivers
- PSPi 6 hardware design by [othermod](https://github.com/othermod) under Creative Commons (CC BY-SA) license
- Community images are provided under the [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/)
- Respect all upstream licenses and attribution requirements

## 🔗 Related Links

- [Official PSPi 6 Project](https://github.com/othermod/PSPi-Version-6) - Hardware, drivers, and official documentation
- [PSPi 6 Hardware](https://othermod.com/product/pspi-6-board/) - Purchase official boards
- [Community Discord](https://discord.gg/V96c3JC) - Support and discussions
- [othermod YouTube](https://youtube.com/othermod) - Video tutorials and updates
