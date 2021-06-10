#!/usr/bin/env bash

print_error() {
    print_in_red "  [✖] $1 $2\n"
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

print_in_green() {
    printf "\e[0;32m%b\e[0m" "$1"
}

print_in_purple() {
    printf "\e[0;35m%b\e[0m" "$1"
}

print_in_red() {
    printf "\e[0;31m%b\e[0m" "$1"
}

print_in_yellow() {
    printf "\e[0;33m%b\e[0m" "$1"
}

print_info() {
    print_in_purple "\n $1\n\n"
}

print_question() {
    print_in_yellow "  [?] $1"
}

print_result() {

    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"

}

print_success() {
    print_in_green "  [✔] $1\n"
}

print_warning() {
    print_in_yellow "  [!] $1\n"
}

show_spinner() {

    local -r FRAMES='/-\|'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local frameText=""
    local frameTextLenght=0
    local i=0
    local j=0
    local numberOfLinesToBeCleared=0
    local terminalWindowWidth=0

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # For commands that require sudo, if the password needs to be
    # provided, wait for the user to provide it before showing the
    # actual spinner
    #
    # (this is kinda hacky, but yeah...)

    if printf "%s" "$CMDS" | grep "sudo" &>/dev/null; then
        while kill -0 "$PID" &>/dev/null \
                && ! sudo -n true &> /dev/null; do
            sleep 0.2
        done
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Display spinner while the commands are being executed

    while kill -0 "$PID" &>/dev/null; do

        frameText="  [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
        numberOfLinesToBeCleared=1

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Print frame text

        printf "%s" "$frameText"
        sleep 0.2

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Clear frame text

        # Notes:
        #
        #  * After the content surpasses the initial terminal height
        #    (the content forces the scroll), `tput sc` (save the cursor
        #    position) and `tput rc` (restore the cursor position) will
        #    no longer be reliable
        #
        # * `tput ed` (clear to end of screen) seems to also not always
        #    be reliable
        #
        # So, in order to work around the shortcomings described above,
        # the clearing of the previous printed content will have to be
        # done "manually".

        # The content may not fit into a single line so there is a
        # need to determine on how many lines it is printed on and
        # clear every single one of those lines

        terminalWindowWidth=$(tput cols)
        frameTextLenght=${#frameText}

        if [ "$terminalWindowWidth" -lt "$frameTextLenght" ]; then
            numberOfLinesToBeCleared=$(( numberOfLinesToBeCleared + ( frameTextLenght / terminalWindowWidth ) ))
        fi

        for j in $(seq 1 $numberOfLinesToBeCleared); do

            # Clear current line

            tput el     # Clear to end of line
            tput el1    # Clear to beginning of line

            # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            # The following line is just so that things look ok on
            # the Travis CI site. The line isn't really needed, but
            # also it doesn't do any harm. However, without it all
            # the frames of the spinner will just be displayed one
            # after the other in a single line.

            printf "\r"

            # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

            # Move up one line if the line containing the starting
            # position of the content has not been reached

            if [ "$j" -lt "$numberOfLinesToBeCleared" ]; then
                tput cuu1
            fi

        done

    done

}

set_trap() {

    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"

}

execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background

    eval "$CMDS" \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete

    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exitCode

}