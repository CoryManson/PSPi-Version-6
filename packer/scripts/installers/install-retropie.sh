#!/bin/bash -e
################################################################################
##  File:  install-pspi6.sh
##  Desc:  This script is used to install Retropie onto a PiOS Aarch64 image.
##         It contains the necessary installation steps and dependencies 
##         required for the installation process.
##  Links: https://retropie.org.uk/docs/Manual-Installation/
##         https://www.youtube.com/watch?v=PAePvz6YSWo
################################################################################
set -x

# Generate a unique log file name using the current timestamp
LOG_FILE="/var/log/install-retropie-$(date +%Y%m%d%H%M%S).log"

# Redirect all output (stdout and stderr) to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Create user "pi" if it doesn't exist
if ! id -u pi > /dev/null 2>&1; then
    useradd -m -s /bin/bash pi || { echo "Failed to create user pi"; exit 1; }
    echo "pi:raspberry" | chpasswd || { echo "Failed to set password for pi"; exit 1; }
    usermod -aG sudo pi || { echo "Failed to add pi to sudo group"; exit 1; }
fi

# Switch to user "pi"
su - pi <<'EOF'

    # Update and upgrade system packages
    sudo apt update
    sudo apt upgrade -y

    # Install required dependencies
    sudo apt install git lsb-release -y

    # Install RetroPie
    cd /opt
    if [ ! -d "/opt/RetroPie-Setup" ]; then
        sudo git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    fi

    cd /opt/RetroPie-Setup || { echo "Failed to change directory to RetroPie-Setup"; exit 1; }
    sudo chmod +x /opt/RetroPie-Setup/retropie_packages.sh || { echo "Failed to set executable permissions on retropie_packages.sh"; exit 1; }

    # Install RetroPie components
    sudo /opt/RetroPie-Setup/retropie_packages.sh retroarch || { echo "Failed to install retroarch"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh emulationstation || { echo "Failed to install emulationstation"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh retropiemenu || { echo "Failed to install retropiemenu"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh runcommand || { echo "Failed to install runcommand"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh samba depends || { echo "Failed to install samba dependencies"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh samba install_shares || { echo "Failed to install samba shares"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh splashscreen default || { echo "Failed to install default splashscreen"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh splashscreen enable || { echo "Failed to enable splashscreen"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh bashwelcometweak || { echo "Failed to install bashwelcometweak"; exit 1; }
    sudo /opt/RetroPie-Setup/retropie_packages.sh joy2key || { echo "Failed to install joy2key"; exit 1; }

    # Enable autostart for EmulationStation
    sudo /opt/RetroPie-Setup/retropie_packages.sh autostart enable || { echo "Failed to enable autostart"; exit 1; }
    sudo sed -i '3i\    sleep 3\n    while pgrep -f "/usr/local/bin/install-retropie.sh" > /dev/null; do\n      sleep 5\n    done' /etc/profile.d/10-retropie.sh

    # Install RetroPie cores
    PACKAGES=$(grep -oP '^\s*"[^"]+"(?=\s*#|$)' /boot/firmware/retropie.conf | tr -d '"')

    for PACKAGE in $PACKAGES; do
        sudo /opt/RetroPie-Setup/retropie_packages.sh "$PACKAGE" || { echo "Failed to install $PACKAGE"; exit 1; }
    done
EOF
