#!/bin/bash

# Exit immediately if any command fails
set -e

# Function to display colored messages
function message {
    if [ "$1" = "success" ]; then
        echo -e "\e[32m[✓] $2\e[0m"
    elif [ "$1" = "error" ]; then
        echo -e "\e[31m[✗] $2\e[0m" >&2
    else
        echo -e "\e[34m[i] $1\e[0m"
    fi
}

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    message error "This script should not be run as root. Run it as a regular user with sudo privileges."
    exit 1
fi

# Update package database
message "Updating package database..."
sudo pacman -Sy --noconfirm
message success "Package database updated"

# Install Docker and dependencies
message "Installing Docker and Docker Compose..."
if sudo pacman -S --noconfirm --needed docker docker-compose; then
    message success "Docker installation complete"
else
    message error "Docker installation failed"
    exit 1
fi

# Enable and start Docker service
message "Starting Docker service..."
sudo systemctl enable --now docker

# Verify Docker service is running
if systemctl is-active --quiet docker; then
    message success "Docker service is running"
else
    message error "Docker service failed to start"
    exit 1
fi

# Add user to docker group
message "Checking Docker group membership..."
if groups | grep -q '\bdocker\b'; then
    message "User is already in the docker group"
else
    read -p "Do you want to add the current user to the docker group? (y/n): " choice
    case "$choice" in 
        y|Y )
            message "Adding user to docker group..."
            sudo usermod -aG docker "$USER"
            
            # Activate the group change without requiring logout
            message "Activating new group membership..."
            if sg docker -c "echo 'Group membership activated for current session'"; then
                message success "You have been added to the docker group. Group membership activated for this session."
                message "Note: You may still need to log out and back in for all applications to recognize the new group."
            else
                message error "Failed to activate group membership. Please log out and back in."
            fi
            ;;
        n|N )
            message "You can use Docker with 'sudo' (e.g., 'sudo docker ps')"
            ;;
        * )
            message "Invalid choice. You can manually add yourself later using: sudo usermod -aG docker \$USER"
            ;;
    esac
fi

# Verify Docker works without sudo
message "Verifying Docker permissions..."
if docker ps >/dev/null 2>&1; then
    message success "Docker is working correctly without sudo!"
elif sudo docker ps >/dev/null 2>&1; then
    message "Docker works with sudo. If you added yourself to the docker group, try:"
    message "1. Logging out and back in"
    message "2. Running: newgrp docker"
else
    message error "Docker doesn't seem to be working. Check installation."
fi

message "Docker setup complete!"