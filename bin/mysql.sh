#!/bin/bash
# MySQL hack by Johan Förberg

CACHEDCMD="$(dirname $0)/.mysql.cmd"

say()
{
   echo "$@" >&2
}

if [ -e "$CACHEDCMD" ]; then
    say Trying saved login details...
    CMD=$(cat "$CACHEDCMD")
    if mysql $CMD $@; then 
        exit
    else
        echo No go!
    fi
fi

# Else

say Fetching login details from Heroku...

URL=$(heroku config:get DATABASE_URL --app karnevalist)
USER=$(echo `expr "$URL" : '^.*//\(.*\):'`)
PASS=$(echo `expr "$URL" : '^.*:\(.*\)@'`)
HOST=$(echo `expr "$URL" : '^.*@\(.*\)/'`)
DB=$(echo `expr "$URL" : '^.*//.*/\(.*\)?'`)

CMD="${DB} --host=${HOST} --user=${USER} --pass=${PASS}"

say Got \`$CMD\`

if mysql $CMD $@; then
    say Saving login details
    printf "$CMD" > "$CACHEDCMD"
    exit
else
    say Command fails
fi
