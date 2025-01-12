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

sudo apt install gpg bat curl wget fzf zsh eza xstow micro gping traceroute net-tools vivid zoxide -y
sudo snap install dog -y

sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

./InstallFonts.sh
./InstallZshPlugins.sh
./InstallEzaTheme.sh

echo -e " [I] Completed. Run 'cd ~/.files; stow .' to link dotfiles."
