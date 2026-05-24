#!/usr/bin/env bash
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/beddu.sh"

DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
REAL_HOME="$HOME"

APT_PACKAGES=(
    gpg nala bat curl wget fzf zsh eza stow micro
    gping traceroute net-tools vivid zoxide flameshot
    git unzip fontconfig lolcat xclip zstd
    unrar-free p7zip-full cabextract
)

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

BREW_PREFIX="/home/linuxbrew/.linuxbrew"

command_exists() { command -v "$1" &>/dev/null; }

ensure_not_root() {
    if [[ "$(id -u)" -eq 0 ]]; then
        throw "This script must be run as your normal user, not as root."
        exit 1
    fi
}

ensure_sudo() {
    if ! command_exists sudo; then
        throw "sudo is not installed."
        exit 1
    fi

    spin "Checking sudo access..."
    if ! sudo true; then
        throw "Cannot obtain sudo access. Check your password/permissions."
        exit 1
    fi
    check "Sudo access confirmed"
}

step_apt() {
    pen bold cyan "System Packages"
    line

    spin "Updating apt repositories..."
    if ! run sudo apt update; then
        throw "apt update failed"
        exit 1
    fi
    check "Apt repositories updated"

    spin "Upgrading existing packages..."
    if ! run sudo apt upgrade -y; then
        throw "apt upgrade failed"
        exit 1
    fi
    check "System packages upgraded"

    spin "Installing packages: ${APT_PACKAGES[*]}"
    if ! run sudo apt install -y "${APT_PACKAGES[@]}"; then
        throw "apt install failed"
        exit 1
    fi
    check "All packages installed"
}

step_ohmyzsh() {
    pen bold cyan "Oh My Zsh"
    line

    if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        check "oh-my-zsh already installed"
        return
    fi

    spin "Cloning oh-my-zsh..."
    if ! run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"; then
        throw "oh-my-zsh installation failed"
        if ! confirm --default-yes "Continue anyway?"; then
            exit 1
        fi
    else
        check "oh-my-zsh installed"
    fi
}

step_zsh_plugins() {
    pen bold cyan "Zsh Plugins"
    line

    local plugins_dir="${ZSH_CUSTOM}/plugins"
    mkdir -p "$plugins_dir"

    declare -A plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
        ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    )

    for name in "${!plugins[@]}"; do
        local dest="$plugins_dir/$name"
        if [[ -d "$dest" ]]; then
            check "Plugin $name already installed"
            continue
        fi
        spin "Cloning zsh plugin: $name"
        if ! run git clone "${plugins[$name]}" "$dest"; then
            throw "Failed to clone $name"
            if ! confirm --default-yes "Continue anyway?"; then
                exit 1
            fi
        else
            check "Plugin $name installed"
        fi
    done
}

step_starship() {
    pen bold cyan "Starship Prompt"
    line

    if command_exists starship; then
        check "starship already installed"
        return
    fi

    spin "Downloading starship installer..."
    local tmp_script
    tmp_script=$(mktemp)
    if ! run curl -fsSL https://starship.rs/install.sh -o "$tmp_script"; then
        rm -f "$tmp_script"
        warn "Failed to download starship installer"
        return
    fi

    spin "Installing starship..."
    mkdir -p "$HOME/.local/bin"
    if ! sh "$tmp_script" -y --bin-dir "$HOME/.local/bin" >/tmp/starship-install.log 2>&1; then
        rm -f "$tmp_script"
        warn "starship installation failed"
        return
    fi
    rm -f "$tmp_script"
    # Ensure ~/.local/bin is in PATH for this session
    export PATH="$HOME/.local/bin:$PATH"
    if command_exists starship; then
        check "starship installed"
    else
        warn "starship installed but not in PATH (restart your shell)"
    fi
}

step_homebrew() {
    pen bold cyan "Homebrew"
    line

    if command_exists brew; then
        check "homebrew already installed"
        return
    fi

    spin "Downloading homebrew installer..."
    local tmp_script
    tmp_script=$(mktemp)
    if ! run curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$tmp_script"; then
        rm -f "$tmp_script"
        warn "Failed to download homebrew installer"
        return 1
    fi

    spop
    spin "Installing homebrew (this may take a few minutes)..."
    NONINTERACTIVE=1 /bin/bash "$tmp_script" >/tmp/brew-install.log 2>&1 || {
        rm -f "$tmp_script"
        warn "homebrew installation failed (check /tmp/brew-install.log for details)"
        return 1
    }
    rm -f "$tmp_script"
    check "homebrew installed"

    if [[ -x "$BREW_PREFIX/bin/brew" ]]; then
        eval "$("$BREW_PREFIX/bin/brew" shellenv)" 2>/dev/null || true
    fi

    spin "Installing doge via homebrew..."
    if brew install doge 2>/tmp/doge-install.log; then
        check "doge installed"
    else
        warn "doge installation failed (check /tmp/doge-install.log)"
    fi
}

step_pipx() {
    pen bold cyan "pipx"
    line

    if [[ ! -x "$BREW_PREFIX/bin/brew" ]]; then
        warn "homebrew not available, skipping pipx"
        return
    fi

    eval "$("$BREW_PREFIX/bin/brew" shellenv)" 2>/dev/null || true

    if command_exists pipx; then
        check "pipx already installed"
        return
    fi

    spin "Installing pipx via homebrew..."
    if ! run brew install pipx; then
        warn "pipx installation failed"
        return
    fi
    check "pipx installed"

    spin "Configuring pipx PATH..."
    if ! run pipx ensurepath; then
        warn "pipx ensurepath failed"
    else
        check "pipx PATH configured"
    fi
}

step_nvm() {
    pen bold cyan "NVM (Node Version Manager)"
    line

    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        check "nvm already installed"
        return
    fi

    spin "Downloading nvm installer..."
    local tmp_script
    tmp_script=$(mktemp)
    if ! run curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o "$tmp_script"; then
        rm -f "$tmp_script"
        warn "Failed to download nvm installer"
        return
    fi

    spin "Installing nvm..."
    if ! bash "$tmp_script" >/tmp/nvm-install.log 2>&1; then
        rm -f "$tmp_script"
        warn "nvm installation failed"
        return
    fi
    rm -f "$tmp_script"
    check "nvm installed (no Node version yet — run 'nvm install --lts' later)"
}

step_opencode() {
    pen bold cyan "OpenCode"
    line

    if command_exists opencode; then
        check "opencode already installed"
        return
    fi

    spin "Downloading opencode installer..."
    local tmp_script
    tmp_script=$(mktemp)
    if ! run curl -fsSL https://opencode.ai/install -o "$tmp_script"; then
        rm -f "$tmp_script"
        warn "Failed to download opencode installer"
        return
    fi

    spin "Installing opencode..."
    if ! bash "$tmp_script" >/tmp/opencode-install.log 2>&1; then
        rm -f "$tmp_script"
        warn "opencode installation failed"
        return
    fi
    rm -f "$tmp_script"
    check "opencode installed"
}

step_fonts() {
    pen bold cyan "Nerd Fonts (CascadiaCode)"
    line

    local font_dir="$HOME/.local/share/fonts"

    if [[ -f "$font_dir/CaskaydiaCoveNerdFontMono-Regular.ttf" ]]; then
        check "CascadiaCode Nerd Font already installed"
        return
    fi

    spin "Downloading and installing CascadiaCode Nerd Font..."
    mkdir -p "$font_dir"

    local tmp_dir
    tmp_dir=$(mktemp -d)
    if ! run wget -q -O "$tmp_dir/CascadiaCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"; then
        rm -rf "$tmp_dir"
        warn "Failed to download CascadiaCode font"
        return
    fi

    if ! run unzip -o "$tmp_dir/CascadiaCode.zip" -d "$font_dir"; then
        rm -rf "$tmp_dir"
        warn "Failed to extract CascadiaCode font"
        return
    fi

    rm -rf "$tmp_dir"
    fc-cache -fv 2>/dev/null || true
    check "CascadiaCode Nerd Font installed"
}

step_eza_theme() {
    pen bold cyan "Eza Theme (Catppuccin)"
    line

    local themes_dir="$HOME/.config/eza/themes"
    local theme_link="$HOME/.config/eza/theme.yml"

    if [[ -L "$theme_link" ]] || [[ -f "$theme_link" ]]; then
        check "eza theme already configured"
        return
    fi

    spin "Cloning eza themes..."
    if ! run --err err git clone https://github.com/eza-community/eza-themes.git "$themes_dir"; then
        warn "Failed to clone eza themes"
        return
    fi
    check "Eza themes cloned"

    spin "Linking Catppuccin theme..."
    mkdir -p "$(dirname "$theme_link")"
    if ! run ln -sf "$themes_dir/themes/catppuccin-mocha.yml" "$theme_link"; then
        warn "Failed to link eza theme"
        return
    fi
    check "Eza Catppuccin theme linked"
}

step_micro_plugins() {
    pen bold cyan "Micro Editor Plugins"
    line

    if ! command_exists micro; then
        warn "micro not installed, skipping plugins"
        return
    fi

    local plugins=(
        "fzf"
        "quoter"
        "detectindent"
        "filemanager"
        "palettero"
    )

    for plugin in "${plugins[@]}"; do
        if [[ -d "$HOME/.config/micro/plug/$plugin" ]]; then
            check "Micro plugin $plugin already installed"
            continue
        fi
        spin "Installing micro plugin: $plugin"
        if ! run micro -plugin install "$plugin"; then
            warn "Failed to install micro plugin: $plugin"
        else
            check "Micro plugin $plugin installed"
        fi
    done
}

step_git_config() {
    pen bold cyan "Git Configuration"
    line

    spin "Setting micro as default git editor..."
    if ! run git config --global core.editor "micro"; then
        warn "Failed to set git editor"
        return
    fi
    check "Git editor set to micro"
}

step_stow() {
    pen bold cyan "Dotfiles Linking"
    line

    if ! command_exists stow; then
        warn "stow not installed, skipping dotfiles linking"
        return
    fi

    if ! confirm "Run 'stow .' in $DOTFILES_DIR to link dotfiles?"; then
        pen "Skipped. Run manually: cd $DOTFILES_DIR && stow ."
        return
    fi

    spin "Linking dotfiles with stow..."
    if ! run stow -d "$DOTFILES_DIR" -t "$REAL_HOME" .; then
        throw "stow failed"
        pen "You may need to resolve conflicts manually: cd $DOTFILES_DIR && stow ."
    else
        check "Dotfiles linked"
    fi
}

main() {
    ensure_not_root
    ensure_sudo

    line
    pen bold cyan "  ╔══════════════════════════════════════════╗"
    pen bold cyan "  ║         TInstaler Linux v2.0             ║"
    pen bold cyan "  ╚══════════════════════════════════════════╝"
    line

    if ! confirm "Start system installation?"; then
        pen "Installation cancelled."
        exit 0
    fi

    step_apt

    line
    step_ohmyzsh
    step_zsh_plugins
    step_starship

    line
    step_homebrew && step_pipx || true
    step_nvm
    step_opencode

    line
    step_fonts
    step_eza_theme
    step_micro_plugins
    step_git_config

    line
    step_stow

    line
    check "Installation complete!"
    pen "Restart your shell or run: exec zsh"
    pen "If your default shell is not zsh, run: chsh -s \$(which zsh)"
}

main "$@"
