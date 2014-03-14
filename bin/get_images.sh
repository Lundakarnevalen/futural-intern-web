#!/bin/bash
# Get images by Johan Förberg
# Multithreaded (!) downloading of images.

download()
{
    filename=fotos/$1.${2##*.}
    if [ -s "$filename" ]; then
        printf '_'
        return 1
    else
        wget $2 -q -O "$filename" &
        printf .
        sleep 0.1
    fi
}

[ -d fotos ] || mkdir fotos
mkfifo image_records
trap 'rm -f image_records' exit

`dirname $0`/mysql.sh --silent --raw <<<'select id, foto from karnevalister where foto is not null;' |
    awk -F $'\t' '{ printf "%s https://karnevalistse.s3.amazonaws.com/uploads/karnevalist/foto/%s/%s\n",
                           $1, $1, $2 }' > image_records &
while read line; do
    download $line
done < image_records

    
