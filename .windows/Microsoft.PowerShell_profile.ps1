#########
# NOTES #
#########

# Unblock-File ***.ps1
# Permite ejecutar un archivo PowerShell sin importar la restriccion.

#
# PERSONAL SETTINGS
#

# OhMyPosh
oh-my-posh init pwsh --config C:\Users\$Env:UserName\AppData\Local\Programs\oh-my-posh\themes\wopian.omp.json | Invoke-Expression



# WeTransfer (Transferwee)
function wetransfer($action, $file) {

    $scriptPath = "C:\Users\$Env:UserName\Documents\Programas\transferwee\transferwee.py"
    python $scriptPath $action $file
}

# New Installation
function TInstall() {
    sudo winget install eza-community.eza GnuWin32.Grep JanDeDobbeleer.OhMyPosh Git.Git Microsoft.PowerShell GNU.nano schollz.croc sharkdp.bat --silent
}

# Comandos ls
Remove-Alias ls
function ls() {
    eza --icons @Args
}

function ll() {
    eza --icons --sort modified --smart-group -l @Args
}

function la(){
    eza --icons --sort modified --smart-group -a @Args
}

function lD(){
    eza --icons -D @Args
}

# Add Grep Path
$env:Path += ";C:\Program Files (x86)\GnuWin32\bin"
