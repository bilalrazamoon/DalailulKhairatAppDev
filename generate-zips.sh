#!/bin/bash

EXAMPLE="Usage: generate-zips name version partial"

name=$1
version=$2
partial=$3

if [[ -z $name ]]; then
    echo "> No name provided"
    echo $EXAMPLE
    exit 1
fi

if [[ -z $version ]]; then
    echo "No version provided"
    echo $EXAMPLE
    exit 1
fi

if [[ -z $partial ]]; then
    echo "No partial provided"
    echo $EXAMPLE
    exit 1
fi

SOURCE="${BASH_SOURCE[0]}"
DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
DEST_DIR=$DIR/downloads
SOURCE_DIR=$DIR/source/$name
TMP_DIR=$DIR/tmp

[ ! -d $TMP_DIR ] && mkdir $TMP_DIR || rm -fr $TMP_DIR/*
cd $TMP_DIR

toCount=$partial
while [[ $toCount -ge 0 ]]; do
    fromCount=$toCount

    DIR_NAME=$name$([[ $version = 0 ]] && echo "" || echo $version)$([[ $partial = 0 ]] && echo "" || echo -$partial)

    if [[ $toCount != 0 && $toCount != $partial ]]; then
        let fromVersion=fromCount-1
        DIR_NAME=$DIR_NAME"_"$version"-"$fromVersion
    fi

    if [[ $toCount != 0 ]]; then
        DIR_NAME=$DIR_NAME"-partial"
    fi

    mkdir $DIR_NAME
    echo $DIR_NAME

    while [[ $fromCount -le $partial ]]; do
        cp $SOURCE_DIR/$fromCount/* $DIR_NAME
        ((fromCount++))
    done

    tar -cvf $DIR_NAME.zip $DIR_NAME
    rm -fr $DIR_NAME
    # break
    ((toCount--))
done
