#!/usr/bin/env sh

# This script sets up prost-demo for running.  It:
#   * Builds BBMap databases for mature, hairpin, biomart.
#   * Uncompresses samples files.

set -e

# Is BBMap in PATH?
if [ ! `which bbmap.sh` ] ; then 
    echo Error: Cannot find bbmap.sh in your \$PATH.
    echo Please add the directory containing your download of BBMap to your \$PATH, like so:
    echo
    echo    export PATH=\$PATH:/path/to/bbmap/
    echo
    exit
fi

# Build BBMap databases
mkdir -p BBMap
cd BBMap
for DB in mature_miRBase21 hairpin_miRBase21 BioMart_Dre79_otherRNA; do
    echo 
    echo Building $DB BBMap database...
    echo
    bbmap.sh k=7 path=$DB ref=../fa/$DB.fa.gz
done

# Uncompress samples files
cd ../samples
gunzip *
