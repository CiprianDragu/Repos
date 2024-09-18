#!/bin/bash

# Update package index
sudo apt update

# Install Node.js and npm
sudo apt install -y nodejs npm

# Verify installation
node -v
npm -v

echo "Node.js and npm have been installed successfully!"


