#!/bin/bash


sudo apt update
sudo apt install i3 picom polybar feh brightnesscctl -y

# Permite cambiar el brillo siendo USER
sudo usermod -aG video $USER

echo -e " [I] Completed. Run 'cd ~/.files; stow .' to link dotfiles."
