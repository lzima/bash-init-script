#!/usr/bin/env bash

TMP_DIR="/tmp"
LOG_FILE="/var/log/setup_laptop.log"

OS_TYPE=""
OS_MACOSX="macosx"
OS_LINUS="linux" # TODO debian, centos ???
OS_WSL="windows_subsystem_linux"
OS_OTHER="other"

function getOS() {
    case "$(uname -sr)" in
        Darwin*)
            echo -n "$OS_MACOSX"
        ;;
        Linux*Microsoft*)
            echo -n "$OS_WSL"
        ;;
        Linux*)
            echo -n "$OS_LINUS"
        ;;
        *)
            echo -n "$OS_OTHER"
        ;;
    esac
}

function log () {
    local file="$1"; shift;
    printf '%b ' "$(date +"%D %T"): $@" '\n' | tee -a "$file"
}

function logError () {
    local file="$1"; shift;
    local message="ERROR: ";
    log "$LOG_FILE" "$message" "$@" >&2
}

function mergeEnvFilesAndLoad() {
    local workdir
    local env_files
    local base_env_file

    workdir="$1"
    env_files=$(ls $workdir/.env.*)
    base_env_file=$workdir/.env

    echo -n > "$base_env_file"

    log "$LOG_FILE" "Merging env files"
    # TODO: refactor, if path to file have whitespace, then this will not work properly
    for env_file in $env_files; do
        log "$LOG_FILE" " - $(basename $env_file)"
        echo >> "$base_env_file"
        cat "$env_file" >> "$base_env_file"
    done

    # load all variables from .env file
    export $(grep -v '^#' "$base_env_file" | xargs) # TODO: issue with loading var value with whitespace (like name "Lubos Zima" -> Loaded just Lubos)
}

function brewInstall() {
    local command_name
    command_name="$1"

    if ! [ "$(command -v $command_name)" ]; then
        log "$LOG_FILE" "installing $command_name"
        brew install $command_name
    fi 
    log "$LOG_FILE" "$command_name installed"
}

function brewInstallCask() {
    local program_name
    program_name="$1"
    
    if ! [ "$(brew list $program_name 2>/dev/null)" ]; then
        log "$LOG_FILE" "installing $program_name"
        brew install --cask $program_name
    fi 
    log "$LOG_FILE" "$program_name installed"
}

if ! [ -f "$LOG_FILE" ]; then
    sudo touch "$LOG_FILE"
    sudo chown $(whoami) "$LOG_FILE"
fi

# load all env variables
mergeEnvFilesAndLoad $(pwd)

OS_TYPE=$(getOS)

log "$LOG_FILE" "Starting setup script"

if [ "$OS_TYPE" == "$OS_MACOSX" ]; then

    # install brew if not exists
    if ! [ "$(command -v brew)" ]; then
        # hotfix for mac pro with intel
        log "$LOG_FILE" "hotfix for mac pro with intel cpu"
        sudo chown -R $(whoami) $(brew --prefix)/*

        log "$LOG_FILE" "installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi 

    log "$LOG_FILE" "homebrew installed"

    brewInstallCask iterm2

    # install zsh if not exists
    if ! [ "$(command -v zsh)" ]; then
        brewInstall zsh
        chsh -s $(which zsh)
        log "$LOG_FILE" "zsh set as a default terminal"

        # customize zsh
        echo "plugins=(git colored-man-pages colorize pip python brew osx)" >> ~/.zshrc
        echo 'PROMPT="%B%F{034}%n@%m%f%b:%B%F{019}%~ %#%f%b "' >> ~/.zshrc
        echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc
        log "$LOG_FILE" "zsh installed"
    fi 

    brewInstall xcode-select
    brewInstall git
    brewInstall ssh
    brewInstallCask rancher
    brewInstall rancher-cli
    brewInstallCask docker
    brewInstall docker-compose
    brewInstall kubernetes-cli
    brewInstall helm
    brewInstall ansible
    brewInstall terraform
fi

# generate ssh keys if not exists
if ! [ -f ~/.ssh/id_ed25519 ]; then
    log "$LOG_FILE" "generating ssh keys"
    ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "$EMAIL" -q -N ""
fi 
log "$LOG_FILE" "ssh keys generated"

git config --global user.name "<$FIRST_NAME $SECOND_NAME>"
git config --global user.email "<$EMAIL>"
git config --list
log "$LOG_FILE" "Git config setup"

