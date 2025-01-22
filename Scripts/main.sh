#!/bin/bash


# ███╗   ███╗ █████╗ ██╗███╗   ██╗
# ████╗ ████║██╔══██╗██║████╗  ██║
# ██╔████╔██║███████║██║██╔██╗ ██║
# ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
# ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
                                
# TInstaler Linux

sudo apt update
sudo apt upgrade -y

sudo apt install gpg bat curl wget fzf zsh eza xstow micro gping traceroute net-tools vivid zoxide flameshot -y
sudo snap install dog -y

# Micro Default Git Editor
git config --global core.editor "micro"

sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sudo curl -sS https://starship.rs/install.sh | sh

./InstallFonts.sh
./InstallZshPlugins.sh
./InstallEzaTheme.sh

echo -e " [I] Completed. Run 'cd ~/.files; stow .' to link dotfiles."
