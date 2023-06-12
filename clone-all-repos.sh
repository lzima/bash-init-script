#!/usr/bin/env bash
# script to clone all repos from a github org

# TODO: use library for functions brewInstall and mergeEnvFilesAndLoad,
# - now two scripts using same functions.
# - move to separate file and source it in both scripts

function brewInstall() {
    local command_name
    local binary_name
    command_name="$1"
    binary_name="$2"

    if [ "$binary_name" == "" ]; then
        binary_name="$command_name"
    fi

    if ! [ "$(command -v $binary_name)" ]; then
        log "$LOG_FILE" "installing $command_name"
        brew install $command_name
    fi
    log "$LOG_FILE" "$command_name installed"
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

# load all env variables
mergeEnvFilesAndLoad $(pwd)

# install gh if not exists
brewInstall gh

gh repo list "$GH_ORG" --limit 1000 | while read -r repo _; do
  gh repo clone "$repo"
done