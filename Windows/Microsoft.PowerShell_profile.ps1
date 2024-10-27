
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58



#
# PERSONAL SETTINGS
#

# OhMyPosh
oh-my-posh init pwsh --config C:\Users\Torre\AppData\Local\Programs\oh-my-posh\themes\wopian.omp.json | Invoke-Expression



# WeTransfer (Transferwee)
function wetransfer($action, $file) {

    $scriptPath = "C:\Users\Torre\Documents\Programas\transferwee\transferwee.py"
    python $scriptPath $action $file
}

# New Installation
function TInstall() {
    sudo winget install eza-community.eza GnuWin32.Grep JanDeDobbeleer.OhMyPosh Git.Git Microsoft.PowerShell --silent
    git clone "https://github.com/Torrenava/.files" "~/Documents/.files"
    mv "~/Documents/.files/Windows/Microsoft.PowerShell_profile.ps1" $PROFILE
}

# Comandos ls
Remove-Alias ls
function ls() {
    eza --icons @Args
}

function ll() {
    eza --icons -l @Args
}

function la(){
    eza --icons -a @Args
}

# Add Grep Path
$env:Path += ";C:\Program Files (x86)\GnuWin32\bin"