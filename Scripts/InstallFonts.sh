mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
unzip CascadiaCode.zip
rm CascadiaCode.zip
fc-cache -fv
