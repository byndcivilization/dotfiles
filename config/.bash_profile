#!/bin/bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source_bash_files() {

    declare -r CURRENT_DIRECTORY="$(pwd)"

    declare -r -a FILES_TO_SOURCE=(
        "bash_aliases"
        "bash_autocomplete"
        "bash_exports"
        "bash_functions"
        "bash_options"
        "bash_prompt"
        "bash.local"  # for local settings that should
                      # not be under version control
    )

    local file=""
    local i=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$(dirname "$(readlink "${BASH_SOURCE[0]}")")" \
        && . "../os/utils.sh"

    # shellcheck disable=SC2034
    declare -r OS="$(get_os)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in ${!FILES_TO_SOURCE[*]}; do

        file="$HOME/.${FILES_TO_SOURCE[$i]}"

        [ -r "$file" ] \
            && . "$file"

    done

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$CURRENT_DIRECTORY"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source_bash_files
unset -f source_bash_files

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clear system messages (e.g.: system copyright notice, the
# date and time of the last login, the message of the day, etc.)

clear
