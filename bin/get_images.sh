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

# Parse opts
while [ $# -gt 0 ]; do
    case "$1" in
        -s)
            sektion=$2
            if ! [ "$sektion" -eq "$sektion" ]; then
                echo "Error: invalid format $sektion"
                exit 1
            fi
            shift
            ;;
        *)
            echo "Error: unregonised opt $1"
            exit 1
            ;;
    esac
    shift
done

[ -d fotos ] || mkdir fotos
mkfifo image_records
trap 'rm -f image_records' exit

where='foto is not null'
if ! [ -z $sektion ]; then
    where="( tilldelad_sektion = $sektion or tilldelad_sektion2 = $sektion ) and $where"
fi

`dirname $0`/mysql.sh --silent --raw <<<"select id, foto from karnevalister where $where" |
    awk -F $'\t' '{ printf "%s https://karnevalistse.s3.amazonaws.com/uploads/karnevalist/foto/%s/%s\n",
                           $1, $1, $2 }' > image_records &
while read line; do
    download $line
done < image_records

    
