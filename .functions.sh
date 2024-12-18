#!/bin/bash

# Function to create a directory and enter it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Check my dotfiles loaded
function mydotfiles() {
    echo "My Dotfiles works!"
    echo "$(pwd)"
}
