#    
#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║     
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#    ███████╗███████║██║  ██║██║  ██║╚██████╗
#    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
#    Configuración ZSH Torrenava
#                                            


# Variables ZSH
export ZSH="$HOME/.oh-my-zsh"

# Otras Configuraciones
export MICRO_TRUECOLOR="1"
export EZA_DEFAULT_OPTIONS="--icons"
zstyle ':omz:plugins:eza' 'icons' yes



# Config ZSH
ZSH_THEME="robbyrussell"
HIST_STAMPS="dd/mm/yyyy"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use aliases sudo zsh-interactive-cd eza fzf)

# | Plugins Download Commands |
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8
export LANGUAGE=es_ES.UTF-8


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='micro'
else   
	export EDITOR='nano'
fi

# Función Extract
# Extráe cualquier archivo comprimido.
function extract {
 if [ $# -eq 0 ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                # Check if it's a gzipped tar file or just a tar file
                if [[ "$n" == *.tar.gz || "$n" == *.tgz ]]; then
                    tar zxvf "$n"
                else
                    tar xvf "$n"
                fi
                ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr|*.rar) unrar x -ad ./"$n" ;;
          *.gz)        gunzip ./"$n"      ;;
          *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba|*.ace) unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                            extract "$n.iso" && \rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                            mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
          *.dmg)
                      hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *.tar.zst)  tar -I zstd -xvf ./"$n"  ;;
          *.zst)      zstd -d ./"$n"  ;;
          *)
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        esac
    done
}

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshc="micro ~/.zshrc" # ZSH Config
alias rzshc="source ~/.zshrc" # Reload ZSH Config

# Aliases Miscelaneos
alias update='sudo apt update && sudo apt upgrade -y && sudo snap refresh'

# Aliases BAT
alias bat="batcat"
alias cat="batcat -pp"

# Aliases EZA (LS)
#alias ls='eza --color=always --group-directories-first --icons'
#alias ll='eza -la --icons --octal-permissions --group-directories-first'
#alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
#alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
#alias la='eza --long --all --group --group-directories-first'
#alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

#alias lS='eza -1 --color=always --group-directories-first --icons'
#alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"
