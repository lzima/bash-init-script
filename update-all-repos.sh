#!/usr/bin/env bash
# script to clone all repos from a github org

# TODO: use library for functions brewInstall and mergeEnvFilesAndLoad,
# - now two scripts using same functions.
# - move to separate file and source it in both scripts
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR_WITH_REPOS="$1"

if [ -z "$DIR_WITH_REPOS" ]; then
    echo "Directory with repos is not set"
    exit 1
fi
if ! [ -d "$DIR_WITH_REPOS" ]; then
    echo "Directory $DIR_WITH_REPOS does not exists"
    exit 1
fi

find "$DIR_WITH_REPOS" -maxdepth 1 -mindepth 1 -type d -exec bash -c "cd '{}' && pwd && git fetch --all && git pull" \;