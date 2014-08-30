#!/bin/bash
# MySQL hack by Johan Förberg

PROGNAME="$(basename $0)"
DIRNAME="$(dirname $0)"
CACHEDCMD="${DIRNAME}/.mysql.cmd"

say()
{
   echo "$@" >&2
}

if [ -e "$CACHEDCMD" ]; then
    say Trying saved login details...
    CMD=$(cat "$CACHEDCMD")
else
    say Fetching login details from Heroku...

    # Make sure renv.production.envfile is set before running this. See README.rdoc
    URL=$(. ${DIRNAME}/renv.sh config:get DATABASE_URL --remote production)
    USER=$(echo `expr "$URL" : '^.*//\(.*\):'`)
    PASS=$(echo `expr "$URL" : '^.*:\(.*\)@'`)
    HOST=$(echo `expr "$URL" : '^.*@\(.*\)/'`)
    DB=$(echo `expr "$URL" : '^.*//.*/\(.*\)?'`)

    CMD="${DB} --host=${HOST} --user=${USER} --password=${PASS}"

    say Got \`$CMD\`

    # 'Validate' command.
    for word in "$USER" "$PASS" "$HOST" "$DB"; do
        if [ -z "$word" ]; then
            say Command looks bogus, aborting
            exit 1
        fi
    done
    # Save command.
    echo $CMD > $CACHEDCMD
fi

case $PROGNAME in
    mysql*)
        if mysql $CMD $@; then
            say Saving login details
            printf "$CMD" > "$CACHEDCMD"
            exit
        else
            say Command fails
            rm -f "$CACHEDCMD"
            exit 1
        fi
        ;;
    dumpdb*)
        mkfifo dumpdb.output
        trap 'rm -f dumpdb.output' exit

        mysqldump $CMD $@ | tee dumpdb.output | xz \
            > karnevalist.se-`date +%Y%m%d`.sql.xz &

        grep -- '-- Dump' < dumpdb.output

        if ! wait $!; then
            say 'Error, cleaning cached command'
            rm -f "$CACHEDCMD"
            exit 1
        fi
        ;;
    *)
        say "Error, invalid command $PROGNAME"
        exit 1
        ;;
esac


