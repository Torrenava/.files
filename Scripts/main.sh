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

sudo apt install gpg nala bat curl wget fzf zsh eza xstow micro gping traceroute net-tools vivid zoxide flameshot -y
sudo snap install dog -y

# Micro Default Git Editor
git config --global core.editor "micro"


./InstallFonts.sh
./InstallZshPlugins.sh
./InstallEzaTheme.sh
./InstallMicroPlugins.sh

echo -e " [+] Run: sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)""
echo -e " [+] Run: sudo curl -sS https://starship.rs/install.sh | sh"
echo -e " [+] Run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)""
echo ""
echo -e " [I] Completed. Run 'cd ~/.files; stow .' to link dotfiles."
