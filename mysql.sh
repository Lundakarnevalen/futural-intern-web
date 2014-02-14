#!/bin/bash
# MySQL hack by Johan Förberg

RUBY='
con = ActiveRecord::Base.connection;
class << con;
  attr_reader :config;
end;

puts "%#{con.config[:database]} --host=#{con.config[:host]} " + 
     "--user=#{con.config[:username]} --pass=#{con.config[:password]}";
exit
'

echo 'Scraping login details from Heroku...'

mysql $(heroku run console <<<$RUBY | grep '^%' | sed 's/^%//')

