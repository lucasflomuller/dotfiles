# 🚀 Cross-Platform Development Environment

Modern Ansible + Chezmoi setup for managing development environments across **macOS** and **Arch Linux**.

## ✨ Features

- **🔄 Cross-platform**: Works seamlessly on macOS and Arch Linux
- **📦 Modular packages**: Install only what you need (essential → development → desktop → hardware)
- **🏠 Dotfiles management**: Automated with chezmoi
- **🎯 One-command setup**: `./setup.sh` and you're done
- **🔧 Idempotent**: Safe to run multiple times
- **⚡ Fast**: Optimized package lists and smart caching

## 🏗️ Architecture

```
ansible/
├── setup.sh              # 🚀 Main setup script
├── ansible.cfg            # ⚙️ Ansible configuration
├── inventory/
│   └── localhost.yml      # 🏠 Local machine config
├── playbooks/
│   ├── setup.yml          # 🎯 Full setup
│   ├── packages-only.yml  # 📦 Packages only
│   └── dotfiles-only.yml  # 🏠 Dotfiles only
├── roles/
│   ├── common/           # 🔧 Base setup (chezmoi, paths)
│   ├── packages/         # 📦 Cross-platform packages
│   └── dotfiles/         # 🏠 Chezmoi management
└── vars/
    ├── Darwin.yml        # 🍎 macOS packages
    └── Archlinux.yml     # 🐧 Arch packages
```

## 🚀 Quick Start

### One-Command Setup

```bash
# Full development environment
./setup.sh

# Essential packages only
./setup.sh --essential-only

# Development environment (no desktop apps)
./setup.sh --dev-only

# Everything including hardware drivers
./setup.sh --full
```

### Manual Setup

```bash
# Install Ansible (if not present)
# macOS: brew install ansible
# Arch: sudo pacman -S ansible

# Install collections
ansible-galaxy collection install community.general

# Run setup
ansible-playbook playbooks/setup.yml
```

## 📦 Package Organization

### Essential (26 packages - Arch / 9 packages - macOS)
Core system tools that work everywhere:
- Package managers, fonts, basic CLI tools
- Network tools (tailscale)
- Essential system components

### Development (42 packages - Arch / 33 packages - macOS)
Complete coding environment:
- **Languages**: Rust, Python, Node.js (via mise)
- **Tools**: git, docker, neovim, tmux
- **CLI utilities**: ripgrep, fzf, bat, eza
- **Databases**: PostgreSQL, MySQL/MariaDB libs
- **Monitoring**: btop, system tools

### Desktop (68 packages - Arch / 11 CLI + 20 GUI - macOS)
**Arch Linux**: Full Hyprland desktop environment
- Window manager, status bars, notifications
- Audio/video, file management
- Fonts and theming

**macOS**: Essential CLI tools + GUI applications
- Terminal tools, media players
- GUI apps via Homebrew Casks

### Hardware-Specific (49 packages - Arch / 2 packages - macOS)
Platform-specific optimizations:
- **Arch**: GPU drivers, power management, device-specific tools
- **macOS**: Minimal (karabiner, lunar) - most handled by OS

## 🎛️ Configuration

### Installation Tiers

Edit `inventory/localhost.yml` to customize:

```yaml
# Package installation tiers
install_essential: true      # Always recommended
install_development: true   # For coding
install_desktop: true       # GUI environment
install_hardware_specific: false  # Hardware drivers/optimization
install_optional: false     # Heavy apps (LibreOffice, OBS, Signal)
```

### Custom Repository

Change the dotfiles repository:

```yaml
chezmoi_repo: "https://github.com/yourusername/dotfiles.git"
```

## 🔄 Usage Examples

```bash
# Initial setup - everything
./setup.sh

# Update packages only
./setup.sh --packages-only

# Update dotfiles only
./setup.sh --dotfiles-only

# Minimal server setup
./setup.sh --essential-only

# Development workstation
./setup.sh --dev-only

# Full desktop with hardware optimization
./setup.sh --full
```

## 📊 Package Comparison

| Category | Arch Linux | macOS | Notes |
|----------|------------|--------|-------|
| **Essential** | 26 | 9 | macOS has more built-ins |
| **Development** | 42 | 33 | Similar core tools |
| **Desktop** | 68 | 31 | Arch needs full DE, macOS is GUI-native |
| **Hardware** | 49 | 2 | macOS handles most hardware |
| **Total** | 185 | 75 | ~60% fewer packages on macOS |

## 🎯 Platform Differences

### Arch Linux
- **Full control**: Complete desktop environment (Hyprland)
- **Comprehensive**: Audio, video, window management
- **Hardware support**: GPU drivers, power management
- **Package managers**: pacman + yay (AUR)

### macOS
- **Streamlined**: OS provides most functionality
- **Homebrew-focused**: CLI tools + GUI applications
- **Native integration**: Uses built-in audio, window management
- **Minimal hardware packages**: macOS handles drivers

## 🛠️ Development

### Testing Changes

```bash
# Test on current machine
ansible-playbook playbooks/setup.yml --check --diff

# Test specific role
ansible-playbook playbooks/setup.yml --tags packages

# Dry run with verbose output
ansible-playbook playbooks/setup.yml --check --diff -v
```

### Adding Packages

1. Edit `vars/Darwin.yml` or `vars/Archlinux.yml`
2. Add to appropriate category (`essential_packages`, `development_packages`, etc.)
3. Test: `./setup.sh --packages-only`

### Customizing Roles

- **common/**: Base setup, chezmoi installation
- **packages/**: OS-specific package installation
- **dotfiles/**: Chezmoi initialization and updates

## 🔧 Troubleshooting

### Common Issues

1. **Ansible not found**: Run setup script to auto-install
2. **Permission denied**: Check sudo access for package installation
3. **Package not found**: Verify package names in OS-specific vars files
4. **Chezmoi errors**: Check repository URL and access permissions

### Debug Mode

```bash
# Verbose output
ansible-playbook playbooks/setup.yml -v

# Extra verbose
ansible-playbook playbooks/setup.yml -vv

# Debug mode
ansible-playbook playbooks/setup.yml --check --diff -vvv
```

## 📋 Requirements

- **macOS**: 10.15+ (Catalina or later)
- **Arch Linux**: Current rolling release
- **Network**: Internet connection for package downloads
- **Permissions**: sudo access for system package installation

## 🎉 What You Get

After running the setup:

✅ **Development Environment**
- Modern shell with starship prompt
- Neovim with LazyVim configuration
- Docker and development tools
- Git with useful aliases and delta

✅ **Cross-Platform Dotfiles**
- Synchronized across all machines
- Platform-specific configurations
- Automatic updates with chezmoi

✅ **Package Management**
- Categorized and optimized package lists
- Easy to customize and maintain
- Idempotent installation

✅ **One-Command Updates**
- `./setup.sh` updates everything
- Selective updates with flags
- Safe to run repeatedly

Your development environment is now ready and will stay in sync across all your machines! 🚀