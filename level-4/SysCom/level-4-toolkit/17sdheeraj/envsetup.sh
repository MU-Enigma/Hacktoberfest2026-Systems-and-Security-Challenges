#!/bin/bash
# usage: ./env_setup.sh
# installs git, curl, and python3 non-interactively on supported distros

# figure out which os or distro we are running on
if [ -f /etc/os-release ]; then
    distro=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')
elif [ "$(uname -s)" = "Darwin" ]; then
    distro="macos"
else
    distro="unknown"
fi

# pick the package manager
case "$distro" in
    ubuntu|debian|pop|mint|kali)
        pkgmgr="apt"
        ;;
    fedora|rhel|centos|rocky|alma)
        pkgmgr="dnf"
        ;;
    arch|manjaro|endeavouros)
        pkgmgr="pacman"
        ;;
    alpine)
        pkgmgr="apk"
        ;;
    opensuse*|sles)
        pkgmgr="zypper"
        ;;
    macos)
        pkgmgr="brew"
        ;;
    *)
        # fallback checks if command exists
        if command -v apt-get >/dev/null 2>&1; then
            pkgmgr="apt"
        elif command -v dnf >/dev/null 2>&1; then
            pkgmgr="dnf"
        elif command -v pacman >/dev/null 2>&1; then
            pkgmgr="pacman"
        elif command -v brew >/dev/null 2>&1; then
            pkgmgr="brew"
        else
            echo "unsupported os: $distro"
            echo "could not detect a supported package manager"
            exit 1
        fi
        ;;
esac

echo "detected distro: $distro (using $pkgmgr)"

# see what is already installed and wot is missing
needed=""

for tool in git curl python3; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "$tool is already installed, skipping"
    else
        echo "$tool is missing, marked for install"
        needed="$needed $tool"
    fi
done

if [ -z "$needed" ]; then
    echo "all tools (git, curl, python3) are already installed, nothing to do"
    exit 0
fi

# check if we need sudo
sudocmd=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        sudocmd="sudo"
    else
        echo "warning: not root and sudo not found, commands might fail"
    fi
fi

echo "installing missing tools:$needed non-interactively"

# run non interactive install per package manager
case "$pkgmgr" in
    apt)
        $sudocmd apt-get update -y -q
        $sudocmd apt-get install -y -q $needed
        ;;
    dnf)
        $sudocmd dnf install -y -q $needed
        ;;
    pacman)
        $sudocmd pacman -Sy --noconfirm $needed
        ;;
    apk)
        $sudocmd apk add --no-cache $needed
        ;;
    zypper)
        $sudocmd zypper --non-interactive in -y $needed
        ;;
    brew)
        brew install $needed
        ;;
esac

exitcode=$?

if [ "$exitcode" -eq 0 ]; then
    echo "setup completed successfully"
else
    echo "install failed with exit code $exitcode"
    exit "$exitcode"
fi
