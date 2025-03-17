#!/bin/bash

# Use the current directory and run Docker Compose
echo "Running Docker Compose in the current directory..."
docker-compose up -d

# Show the status of running containers
echo "Showing container status:"
docker ps
