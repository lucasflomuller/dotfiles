#!/bin/bash
# Cross-platform development environment setup script
# Works on macOS and Arch Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="Darwin"
    elif [[ -f "/etc/arch-release" ]]; then
        OS="arch"
        DISTRO="Archlinux"
    else
        error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Install Ansible
install_ansible() {
    log "Installing Ansible for $OS..."

    case $OS in
        "macos")
            # Check if Homebrew is installed (check for binary file existence)
            BREW_EXISTS=false
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
                BREW_EXISTS=true
                log "Found Homebrew at /opt/homebrew/bin/brew"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
                BREW_EXISTS=true
                log "Found Homebrew at /usr/local/bin/brew"
            fi

            if [[ "$BREW_EXISTS" == "false" ]]; then
                log "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                # Add Homebrew to PATH for current session
                if [[ -f "/opt/homebrew/bin/brew" ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                elif [[ -f "/usr/local/bin/brew" ]]; then
                    eval "$(/usr/local/bin/brew shellenv)"
                fi

                # Verify brew is now available
                if ! command -v brew &> /dev/null; then
                    error "Homebrew installation failed or brew command not found in PATH"
                    exit 1
                fi

                success "Homebrew installed and added to PATH"
            else
                success "Homebrew is already installed"
            fi

            brew install ansible
            ;;
        "arch")
            sudo pacman -S --needed ansible
            ;;
    esac
}

# Install Ansible collections
install_collections() {
    log "Installing required Ansible collections..."
    ansible-galaxy collection install community.general
}

# Run setup
run_setup() {
    log "Starting development environment setup..."

    # Parse command line arguments
    PLAYBOOK="playbooks/setup.yml"
    EXTRA_VARS=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --essential-only)
                EXTRA_VARS="$EXTRA_VARS install_development=false install_desktop=false"
                shift
                ;;
            --dev-only)
                EXTRA_VARS="$EXTRA_VARS install_desktop=false install_hardware_specific=false"
                shift
                ;;
            --full)
                EXTRA_VARS="$EXTRA_VARS install_hardware_specific=true install_optional=true"
                shift
                ;;
            --packages-only)
                PLAYBOOK="playbooks/packages-only.yml"
                shift
                ;;
            --dotfiles-only)
                PLAYBOOK="playbooks/dotfiles-only.yml"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                warn "Unknown option: $1"
                shift
                ;;
        esac
    done

    # Run Ansible playbook
    if [[ -n "$EXTRA_VARS" ]]; then
        ansible-playbook "$PLAYBOOK" --extra-vars "$EXTRA_VARS"
    else
        ansible-playbook "$PLAYBOOK"
    fi
}

show_help() {
    cat << EOF
🚀 Cross-platform Development Environment Setup

Usage: $0 [OPTIONS]

OPTIONS:
    --essential-only    Install only essential packages
    --dev-only          Install essential + development packages (no desktop)
    --full              Install everything including hardware-specific packages
    --packages-only     Only install packages (skip dotfiles)
    --dotfiles-only     Only apply dotfiles (skip packages)
    --help, -h          Show this help message

EXAMPLES:
    $0                  # Full setup (essential + dev + desktop)
    $0 --essential-only # Minimal setup
    $0 --dev-only       # Development environment only
    $0 --full           # Everything including hardware drivers
    $0 --dotfiles-only  # Update dotfiles only

The setup will automatically detect your OS ($DISTRO) and install appropriate packages.
EOF
}

main() {
    echo "🚀 Development Environment Setup"
    echo "================================"

    detect_os
    success "Detected OS: $DISTRO"

    # Check if we're in the right directory, and change to ansible dir if needed
    if [[ ! -f "ansible.cfg" ]]; then
        if [[ -f "ansible/ansible.cfg" ]]; then
            log "Changing to ansible directory..."
            cd ansible
        else
            error "Cannot find ansible directory. Please run from repository root or ansible directory"
            exit 1
        fi
    fi

    # Install Ansible if not present
    if ! command -v ansible &> /dev/null; then
        install_ansible
        install_collections
    else
        log "Ansible is already installed"
    fi

    # Run the setup
    run_setup "$@"

    success "🎉 Setup completed successfully!"
    log "Your development environment is ready to use."
}

# Run main function with all arguments
main "$@"