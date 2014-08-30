#!/bin/bash
# Remote Environment Management
# https://github.com/larsnystrom/renv

# Constants
declare -r TAB=$'\t'
declare -r EOL=$'\n'
declare -r USAGE="Usage: `basename $0` config[:get|:set|:unset] [--host ssh_host|--remote git_remote] [--env-file path]"

function ssh_get_line {
    local __return=$1
    local line=`ssh $HOST cat "$ENV_FILE" | grep "^\<export\> ${KEY}="`
    eval $__return="'$line'"
}

function ssh_get_val {
    local __return=$2
    local val=`expr "$1" : "^\<export\> [^=]*=\(.*\)"`
    eval $__return="'$val'"
}

function confirm {
    read -p "${1} (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting"
        exit 0
    fi
}

# Defaults
REMOTE=
ENV_FILE=""
PARAMS=()
HOST=

# Arguments
while [[ $# > 1 ]]; do
    key="$1"
    shift

    case $key in
        -r|--remote)
            REMOTE="$1"
            shift
            ;;
        -e|--env-file)
            ENV_FILE="$1"
            shift
            ;;
        -h|--host)
            HOST="$1"
            shift
            ;;
        *)
            PARAMS+=("$key")
            ;;
    esac
done

# Trailing param
[ -n "$1" ] && { PARAMS+=("$1"); }

# Naive usage check
[ ${#PARAMS[@]} -eq 0 ] && { echo "$USAGE"; exit 1; }

# Try git remote if no host is specified
if [ -z "$HOST" ] && [ -n "$REMOTE" ]; then
    # Require git
    if ! hash git > /dev/null 2>&1; then
        echo "Git must be installed to use a Git remote."
        exit 1
    fi

    # Check if inside a git repository
    git status > /dev/null 2>&1
    if [ $? == 128 ]; then
        echo "Not a git repository, or other git error. Run \"git status\" for more information."
        exit 1
    fi

    # Get git remote
    GIT_REMOTE=`git remote -v | grep "$REMOTE" | grep "fetch"`
    if [[ $GIT_REMOTE = *$EOL* ]]; then
        echo "Ambigous remote \"$REMOTE\"."
        exit 1
    fi

    if [ -z "$GIT_REMOTE" ]; then
        echo "\"$REMOTE\" is not a remote in this repository."
        exit 1
    fi

    HOST=`expr "$GIT_REMOTE" : "^.*${TAB}\(.*\):.* "`
    REMOTE_DIR=`expr "$GIT_REMOTE" : "^.*${TAB}.*@.*:\(.*\) "`

    # If ENV_FILE isn't set, try to get it from git config
    if [ -z "$ENV_FILE" ]; then
        ENV_FILE=`git config --get renv.${REMOTE}.envfile`
    fi

    # If ENV_FILE isn't set, try remote .env file
    if [ -z "$ENV_FILE" ]; then
        ENV_FILE="${REMOTE_DIR}/.env"
    fi
fi

# Last check
[ -z "$HOST" ] && { echo "No host or remote specified."; exit 1; }
[ -z "$ENV_FILE" ] && { echo "No remote .env file specified."; exit 1; }

APP=`expr "$HOST" : '.*@\([^:/]*\)'`

# Check if file exists on remote
if ! ssh $HOST stat $ENV_FILE \> /dev/null 2\>\&1; then
    echo "\"$ENV_FILE\" doesn't exist on the remote. Try specifying path with the --env-file argument."
    exit 1
fi

case $PARAMS[0] in
    config:get*)
        [ "${#PARAMS[@]}" != 2 ] && { echo "No key specified."; exit 1; }

        KEY="${PARAMS[1]}"
        ssh_get_line LINE
        ssh_get_val "$LINE" VAL

        echo "$VAL"
        exit 0
        ;;
    config:set*)
        [ "${#PARAMS[@]}" != 2 ] && { echo "No key specified."; exit 1; }

        KEY=`expr "${PARAMS[1]}" : "\([^=]*\)=.*"`
        NEW_VAL=`expr "${PARAMS[1]}" : "[^=]*=\(.*\)"`
        ssh_get_line LINE
        ssh_get_val "$LINE" VAL

        if [ "$VAL" = "$NEW_VAL" ]; then
            echo "${KEY}=${NEW_VAL}"
            exit 0
        fi

        if [ -n "$LINE" ]; then
            ssh $HOST "sed -i \"s|export ${KEY}=${VAL}|export ${KEY}=${NEW_VAL}|\" \"$ENV_FILE\""
        else
            echo "export ${KEY}=${NEW_VAL}" | ssh $HOST "cat >> \"$ENV_FILE\""
        fi

        echo "${KEY}=${NEW_VAL}"
        exit 0
        ;;
    config:unset*)
        [ "${#PARAMS[@]}" != 2 ] && { echo "No key specified."; exit 1; }

        KEY="${PARAMS[1]}"
        ssh_get_line LINE

        [ -z "$LINE" ] && { echo "No such key."; exit 1; }

        confirm "Do you wish to unset \"$KEY\"?"

        ssh $HOST "sed -i \"/$KEY/d\" $ENV_FILE"
        exit 0
        ;;
    config*)
        ENV=`ssh $HOST cat "$ENV_FILE"`
        KEYS=()
        VALS=()
        MAX_LEN=0
        while read -r line; do
            if [ -n "$line" ]; then
                KEYS+=(`expr "$line" : "^\<export\> \([^=]*\)=.*"`)
                VALS+=(`expr "$line" : "^\<export\> [^=]*=\(.*\)"`)
            fi

            # Get the length of the last string.
            # [Get the string length at (length of array - 1)]
            LENGTH_LAST=${#KEYS[${#KEYS[@]} - 1]}

            [ "$LENGTH_LAST" -gt "$MAX_LEN" ] && { MAX_LEN=${LENGTH_LAST}; }
        done <<< "$ENV"

        echo "=== $APP Config Vars"
        for i in "${!KEYS[@]}"; do
            KEY=${KEYS[${i}]}
            LEN=${#KEY}

            echo -n "${KEY}:"
            for k in $(seq $LEN $MAX_LEN); do
                echo -n " "
            done
            echo ${VALS[${i}]}
        done
        exit 0
        ;;
    *)
        echo "Invalid command \"${PARAMS[0]}\""
        exit 1
        ;;
esac
