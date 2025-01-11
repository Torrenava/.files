#!/bin/bash


git clone https://github.com/eza-community/eza-themes.git ~/.config/eza/themes
mkdir -p ~/.config/eza
ln -sf ~/.config/eza/themes/themes/catppuccin.yml ~/.config/eza/theme.yml
