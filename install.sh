#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Step 1: Update and Upgrade the System
echo "Updating system..."
apt-get update && apt-get upgrade -y

# Step 2: Install Necessary Dependencies
echo "Installing required packages..."
apt-get install -y build-essential wget libxml2-dev libncurses5-dev libsqlite3-dev uuid-dev libjansson-dev

# Optional: Install MP3 support for Music On Hold
echo "Installing MP3 support..."
apt-get install -y libmp3lame-dev

# Step 3: Download and Install Asterisk
echo "Downloading Asterisk..."
cd /usr/src
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
tar xvf asterisk-18-current.tar.gz
cd asterisk-18*

# Configure Asterisk
echo "Configuring Asterisk..."
./configure --with-jansson-bundled

# Remove the existing menuselect.makeopts
make menuselect.makeopts

# Enable add-ons
menuselect/menuselect --enable format_mp3 menuselect.makeopts

# Compile and Install Asterisk
echo "Compiling and installing Asterisk..."
make && make install
make samples
make config

# Step 4: Set Up Basic Configuration
echo "Setting up basic configuration..."
systemctl start asterisk
systemctl enable asterisk

echo "Asterisk installation complete. You may now configure your dial plans and settings."

