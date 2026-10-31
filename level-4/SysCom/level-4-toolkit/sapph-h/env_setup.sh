#!/usr/bin/env bash
# Detects the OS/distribution and installs git, curl, and Python 3
# non-interactively where a supported package manager is available.
# Usage: ./env_setup.sh

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

log() {
    printf '[*] %s\n' "$1"
}

success() {
    printf '[+] %s\n' "$1"
}

fail() {
    printf '[!] %s\n' "$1" >&2
    exit 1
}

# to run package manager commands as root when needed
run_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo -n "$@"
    else
        fail "Root privileges are required, but sudo is unavailable."
    fi
}

# js installing packages that are missing
missing_packages() {
    local pkg
    for pkg in "$@"; do
        case "$pkg" in
            git) command -v git >/dev/null 2>&1 || printf '%s\n' "$pkg" ;;
            curl) command -v curl >/dev/null 2>&1 || printf '%s\n' "$pkg" ;;
            python3) command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || printf '%s\n' "$pkg" ;;
        esac
    done
}

install_apt() {
    local packages
    packages="$(missing_packages git curl python3)"
    [ -z "$packages" ] && {
        success "git, curl, and Python 3 are already installed."
        return
    }

    log "Using apt..."
    run_root apt-get update -y
    run_root apt-get install -y $packages
}

install_dnf() {
    local packages
    packages="$(missing_packages git curl python3)"
    [ -z "$packages" ] && {
        success "git, curl, and Python 3 are already installed."
        return
    }

    log "Using dnf..."
    run_root dnf install -y $packages
}

install_pacman() {
    local packages=()

    command -v git >/dev/null 2>&1 || packages+=(git)
    command -v curl >/dev/null 2>&1 || packages+=(curl)
    if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
        packages+=(python)
    fi

    [ "${#packages[@]}" -eq 0 ] && {
        success "git, curl, and Python 3 are already installed."
        return
    }

    log "Using pacman..."
    run_root pacman -Sy --noconfirm --needed "${packages[@]}"
}

install_brew() {
    local packages=()

    command -v git >/dev/null 2>&1 || packages+=(git)
    command -v curl >/dev/null 2>&1 || packages+=(curl)
    if ! command -v python3 >/dev/null 2>&1; then
        packages+=(python)
    fi

    [ "${#packages[@]}" -eq 0 ] && {
        success "git, curl, and Python 3 are already installed."
        return
    }

    log "Using Homebrew..."
    brew install "${packages[@]}"
}

detect_and_install() {
    local os
    os="$(uname -s)"

    case "$os" in
        Linux)
            if [ -r /etc/os-release ]; then
                . /etc/os-release
                distro="${ID:-unknown}"
                log "Detected Linux distribution: ${PRETTY_NAME:-$distro}"

                case "$distro" in
                    ubuntu|debian|linuxmint|pop|elementary|kali)
                        install_apt
                        ;;
                    fedora|rhel|centos|rocky|almalinux)
                        install_dnf
                        ;;
                    arch|manjaro|endeavouros|cachyos)
                        install_pacman
                        ;;
                    *)
                        fail "Unsupported Linux distribution: ${distro}. Supported families: Debian/Ubuntu, Fedora/RHEL, and Arch."
                        ;;
                esac
            else
                fail "Unable to detect the Linux distribution!"
            fi
            ;;
        Darwin)
            log "Detected macOS."
            if command -v brew >/dev/null 2>&1; then
                install_brew
            else
                fail "Homebrew is not installed. Install Homebrew first; this script will not launch an interactive installer."
            fi
            ;;
        *)
            fail "Unsupported operating system: $os"
            ;;
    esac
}

detect_and_install

# seeing if everything's cool
command -v git >/dev/null 2>&1 || fail "git installation failed."
command -v curl >/dev/null 2>&1 || fail "curl installation failed."
if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
    fail "Python 3 installation failed."
fi

success "Environment setup complete."
printf '    git:    %s\n' "$(git --version)"
printf '    curl:   %s\n' "$(curl --version | head -n 1)"
if command -v python3 >/dev/null 2>&1; then
    printf '    python: %s\n' "$(python3 --version)"
else
    printf '    python: %s\n' "$(python --version)"
fi
