#!/bin/bash -e
################################################################################
##  File:  install-pspi6.sh
##  Desc: This script is used to install Retropie onto a PiOS arch64 image. It contains the necessary installation steps and dependencies required for the installation process.
##  https://retropie.org.uk/docs/Manual-Installation/
##  https://www.youtube.com/watch?v=PAePvz6YSWo
################################################################################
set -x

# Add a file to track installation progress
PROGRESS_FILE="/opt/retropie_installation_progress"

# Function to check if a step is complete
is_step_complete() {
    grep -q "$1" "$PROGRESS_FILE" 2>/dev/null
}

# Function to mark a step as complete
mark_step_complete() {
    echo "$1" >> "$PROGRESS_FILE"
}

# Ensure the progress file exists
sudo touch "$PROGRESS_FILE"
sudo chmod 666 "$PROGRESS_FILE"

# Update and upgrade system
if ! is_step_complete "update_upgrade"; then
    sudo apt update
    sudo apt upgrade -y
    mark_step_complete "update_upgrade"
fi

# Install dependencies
if ! is_step_complete "install_dependencies"; then
    sudo apt install git lsb-release -y
    sudo systemctl disable install-retropie.service
    mark_step_complete "install_dependencies"
fi

# Install RetroPie
if ! is_step_complete "clone_retropie"; then
    cd /opt
    if [ ! -d "/opt/RetroPie-Setup" ]; then
        sudo git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    fi
    mark_step_complete "clone_retropie"
fi

if ! is_step_complete "setup_retropie"; then
    cd /opt/RetroPie-Setup
    sudo chmod +x /opt/RetroPie-Setup/retropie_packages.sh

    # Break down each retropie_packages.sh command into its own step
    if ! is_step_complete "install_retroarch"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh retroarch
        mark_step_complete "install_retroarch"
    fi

    if ! is_step_complete "install_emulationstation"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh emulationstation
        mark_step_complete "install_emulationstation"
    fi

    if ! is_step_complete "install_retropiemenu"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh retropiemenu
        mark_step_complete "install_retropiemenu"
    fi

    if ! is_step_complete "install_runcommand"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh runcommand
        mark_step_complete "install_runcommand"
    fi

    if ! is_step_complete "install_samba_depends"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh samba depends
        mark_step_complete "install_samba_depends"
    fi

    if ! is_step_complete "install_samba_shares"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh samba install_shares
        mark_step_complete "install_samba_shares"
    fi

    if ! is_step_complete "install_splashscreen_default"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh splashscreen default
        mark_step_complete "install_splashscreen_default"
    fi

    if ! is_step_complete "enable_splashscreen"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh splashscreen enable
        mark_step_complete "enable_splashscreen"
    fi

    if ! is_step_complete "install_bashwelcometweak"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh bashwelcometweak
        mark_step_complete "install_bashwelcometweak"
    fi

    if ! is_step_complete "enable_autostart"; then
        sudo /opt/RetroPie-Setup/retropie_packages.sh autostart enable
        mark_step_complete "enable_autostart"
    fi

    mark_step_complete "setup_retropie"
fi

if ! is_step_complete "gzdoom"; then
    sudo /opt/RetroPie-Setup/retropie_packages.sh gzdoom
    mark_step_complete "gzdoom"
fi

sudo systemctl disable install-retropie.service