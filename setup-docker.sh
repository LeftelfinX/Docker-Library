#!/bin/bash

# Update package database
sudo pacman -Sy --noconfirm

# Install Docker and dependencies
if sudo pacman -S --noconfirm --needed docker docker-compose; then
    echo "Docker installation complete."
else
    echo "Docker installation failed. Exiting."
    exit 1
fi

# Enable and start Docker service
sudo systemctl enable --now docker

# Check if Docker service is running
if systemctl is-active --quiet docker; then
    echo "Docker service is running."
else
    echo "Docker service failed to start. Exiting."
    exit 1
fi

# Ask user if they want to be added to the docker group
read -p "Do you want to add the current user to the docker group? (y/n): " choice
case "$choice" in 
  y|Y )
    sudo usermod -aG docker $USER
    echo "You have been added to the docker group. Please log out and log back in for the changes to take effect."
    ;;
  n|N )
    echo "You can use Docker now, but you need to use 'sudo' with Docker commands."
    ;;
  * )
    echo "Invalid choice. You can manually add yourself to the docker group later using: sudo usermod -aG docker \$USER"
    ;;
esac
