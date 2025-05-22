#!/bin/bash

# WezTerm Nightly Build and Install Script for Debian/Ubuntu
# This script builds WezTerm from the latest main branch and installs it

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Debian/Ubuntu
check_os() {
    if ! command -v apt-get &> /dev/null; then
        print_error "This script is designed for Debian/Ubuntu systems with apt-get"
        exit 1
    fi
    
    # Get OS info
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        print_status "Detected OS: $NAME $VERSION"
    fi
}

# Install build dependencies
install_dependencies() {
    print_status "Updating package list..."
    sudo apt-get update
    
    print_status "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential \
        pkg-config \
        libssl-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libxcb-xfixes0-dev \
        libxcb-shape0-dev \
        libxcb-xkb-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        libegl1-mesa-dev \
        libwayland-dev \
        libx11-xcb-dev \
        libxcb-render0-dev \
        libxcb-render-util0-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-keysyms1-dev \
        libxcb-randr0-dev \
        libxcb-shape0-dev \
        libxcb-sync-dev \
        libxcb-xfixes0-dev \
        libxcb-xinerama0-dev \
        libxcb-dri3-dev \
        libxcb-cursor-dev \
        python3 \
        python3-pip \
        git \
        curl \
        ca-certificates
        
    print_success "Dependencies installed successfully"
}

# Install Rust
install_rust() {
    if command -v rustc &> /dev/null; then
        print_status "Rust is already installed: $(rustc --version)"
        print_status "Updating Rust..."
        rustup update stable
    else
        print_status "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
        source "$HOME/.cargo/env"
        print_success "Rust installed: $(rustc --version)"
    fi
    
    # Ensure cargo is in PATH
    export PATH="$HOME/.cargo/bin:$PATH"
}

# Clone or update WezTerm repository
setup_repo() {
    WEZTERM_DIR="$HOME/wezterm-nightly"
    
    if [[ -d "$WEZTERM_DIR" ]]; then
        print_status "Updating existing WezTerm repository..."
        cd "$WEZTERM_DIR"
        git fetch origin
        git reset --hard origin/main
        git clean -fd
    else
        print_status "Cloning WezTerm repository..."
        git clone https://github.com/wez/wezterm.git "$WEZTERM_DIR"
        cd "$WEZTERM_DIR"
    fi
    
    COMMIT_HASH=$(git rev-parse --short HEAD)
    print_status "Building from commit: $COMMIT_HASH"
    print_status "Commit message: $(git log -1 --pretty=format:'%s')"
}

# Build WezTerm
build_wezterm() {
    print_status "Building WezTerm nightly (this will take several minutes)..."
    cd "$WEZTERM_DIR"
    
    # Clean any previous builds
    cargo clean
    
    # Build with optimizations
    CARGO_PROFILE_RELEASE_LTO=fat \
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 \
    cargo build --release --bin wezterm --bin wezterm-gui --bin wezterm-mux-server
    
    print_success "Build completed successfully!"
    
    # Show build info
    print_status "Binary location: $WEZTERM_DIR/target/release/wezterm"
    print_status "Binary size: $(du -h $WEZTERM_DIR/target/release/wezterm | cut -f1)"
}

# Install WezTerm
install_wezterm() {
    print_status "Installing WezTerm..."
    cd "$WEZTERM_DIR"
    
    # Backup existing installation if it exists
    if [[ -f /usr/local/bin/wezterm ]]; then
        print_status "Backing up existing installation..."
        sudo cp /usr/local/bin/wezterm /usr/local/bin/wezterm.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Install binaries
    sudo cp target/release/wezterm /usr/local/bin/
    sudo cp target/release/wezterm-gui /usr/local/bin/
    sudo cp target/release/wezterm-mux-server /usr/local/bin/
    sudo chmod +x /usr/local/bin/wezterm*
    
    # Install desktop file
    sudo mkdir -p /usr/local/share/applications
    if [[ -f assets/wezterm.desktop ]]; then
        sudo cp assets/wezterm.desktop /usr/local/share/applications/
    else
        # Create desktop file if it doesn't exist
        sudo tee /usr/local/share/applications/wezterm.desktop > /dev/null << EOF
[Desktop Entry]
Name=WezTerm
Comment=A GPU-accelerated cross-platform terminal emulator
Exec=/usr/local/bin/wezterm
Icon=wezterm
Type=Application
Categories=System;TerminalEmulator;
Keywords=terminal;shell;
StartupNotify=true
EOF
    fi
    
    # Install icon
    sudo mkdir -p /usr/local/share/pixmaps
    if [[ -f assets/icon/terminal.png ]]; then
        sudo cp assets/icon/terminal.png /usr/local/share/pixmaps/wezterm.png
    fi
    
    # Install man page if it exists
    if [[ -f docs/wezterm.1 ]]; then
        sudo mkdir -p /usr/local/share/man/man1
        sudo cp docs/wezterm.1 /usr/local/share/man/man1/
        sudo gzip -f /usr/local/share/man/man1/wezterm.1
    fi
    
    # Update desktop database
    if command -v update-desktop-database &> /dev/null; then
        sudo update-desktop-database /usr/local/share/applications/ 2>/dev/null || true
    fi
    
    print_success "WezTerm nightly installed successfully!"
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    if command -v wezterm &> /dev/null; then
        INSTALLED_VERSION=$(wezterm --version)
        print_success "WezTerm installed: $INSTALLED_VERSION"
        print_status "Installation path: $(which wezterm)"
    else
        print_error "WezTerm not found in PATH after installation"
        exit 1
    fi
}

# Create uninstall script
create_uninstall_script() {
    UNINSTALL_SCRIPT="$HOME/uninstall-wezterm-nightly.sh"
    cat > "$UNINSTALL_SCRIPT" << 'EOF'
#!/bin/bash
echo "Uninstalling WezTerm nightly..."
sudo rm -f /usr/local/bin/wezterm*
sudo rm -f /usr/local/share/applications/wezterm.desktop
sudo rm -f /usr/local/share/pixmaps/wezterm.png
sudo rm -f /usr/local/share/man/man1/wezterm.1.gz
rm -rf "$HOME/wezterm-nightly"
echo "WezTerm nightly uninstalled successfully!"
EOF
    chmod +x "$UNINSTALL_SCRIPT"
    print_status "Uninstall script created: $UNINSTALL_SCRIPT"
}

# Main execution
main() {
    print_status "Starting WezTerm nightly build and installation..."
    
    check_os
    install_dependencies
    install_rust
    setup_repo
    build_wezterm
    install_wezterm
    verify_installation
    create_uninstall_script
    
    print_success "WezTerm nightly installation completed!"
    print_status "You can now run 'wezterm' from anywhere in your terminal"
    print_status "Source code location: $HOME/wezterm-nightly"
    print_status "To uninstall, run: $HOME/uninstall-wezterm-nightly.sh"
    
    # Offer to clean build artifacts
    echo
    read -p "Do you want to clean build artifacts to save disk space? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$HOME/wezterm-nightly"
        cargo clean
        print_status "Build artifacts cleaned"
    fi
}

# Run main function
main "$@"
