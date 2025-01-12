#!/bin/bash


sudo apt update
sudo apt install i3 picom polybar feh brightnesscctl -y

echo -e " [I] Completed. Run 'cd ~/.files; stow .' to link dotfiles."