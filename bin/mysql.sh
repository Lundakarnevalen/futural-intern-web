#!/bin/bash
# MySQL hack by Johan Förberg

CACHEDCMD="$(dirname $0)/.mysql.cmd"

RUBY='
con = ActiveRecord::Base.connection;
class << con;
  attr_reader :config;
end;

puts "%#{con.config[:database]} --host=#{con.config[:host]} " + 
     "--user=#{con.config[:username]} --pass=#{con.config[:password]}";
exit
'

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

say Scraping login details from Heroku...

if CMD=$(heroku run console --app karnevalist <<<$RUBY | grep '^%' | sed 's/^%//'); then
    say Got \`$CMD\`

    if mysql $CMD $@; then 
        say Saving login details
        printf "$CMD" > "$CACHEDCMD"
        exit
    else
        say Command fails
    fi
else
    say Scrape fails
    exit 1
fi

