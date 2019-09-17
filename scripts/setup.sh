#!/usr/bin/env bash

# This script sets up prost-demo for running.  It:
#   * Checks for presence of BBMap.
#   * Uncompresses samples files and annotation files.

set -e

# Is BBMap in PATH?
if [ ! `which bbmap.sh 2>/dev/null` ] ; then
    echo Error: Cannot find bbmap.sh in your \$PATH.
    echo Please add the directory containing your download of BBMap to your \$PATH, like so:
    echo
    echo    export PATH=\$PATH:/path/to/bbmap/
    echo
    exit
fi

# This script needs to be run
if [ ! -d fa ] || [ ! -d samples ] ; then i
    echo Error: Please run this script from the top directory.
    echo In other words, run this script like so:
    echo
    echo "    bash scripts/setup.sh"
    echo
    exit
fi

# Uncompress annotation and samples files
if [[ `ls fa/*.gz 2>/dev/null` ]] ; then gunzip fa/*.gz ; fi
if [[ `ls samples/*.gz 2>/dev/null` ]] ; then gunzip samples/*.gz ; fi

# Get the ZF assembly.
ASSEMBLY=ftp://ftp.ensembl.org/pub/release-90/fasta/danio_rerio/dna/Danio_rerio.GRCz10.dna.toplevel.fa.gz
if [ -e Danio_rerio.GRCz10.dna.toplevel.fa.gz ] ; then
    # Already downloaded: noop.
    :
elif [ `which wget` ] ; then
    echo "Downloading Danio_rerio.GRCz10.dna.toplevel.fa.gz.  This may take a few minutes..."
    wget $ASSEMBLY 2> /dev/null || \
        echo "Error, couldn't download $ASSEMBLY (using wget)." && exit 1
elif [ `which curl` ] ; then
    echo "Downloading Danio_rerio.GRCz10.dna.toplevel.fa.gz.  This may take a few minutes..."
    curl -O $ASSEMBLY 2> /dev/null || \
        echo "Error, couldn't download $ASSEMBLY (using curl)." && exit 1
else
    echo "Error: Your system does not have 'wget' or 'curl' installed, so I cannot"
    echo "       download Danio_rerio.GRCz10.dna.toplevel.fa.gz for you. Please retrieve"
    echo "       the file $ASSEMBLY"
    echo "       and place it in the current directory, then try again."
    echo Exiting.
    exit
fi

# Build the BBMap DB.
echo "Building BBMap database of Danio_rerio.GRCz10.dna.toplevel.fa.gz.  This may take a few minutes..."
echo "    If you wish to run Prost! on a species besides zebrafish, you'll need to be able to "
echo "    build your own BBMap databases. For your reference, here's how I'm building "
echo "    the zebrafish BBMap database:"
echo
echo "    bbmap.sh k=7 path=BBMap/Danio_rerio.GRCz10.dna.toplevel ref=Danio_rerio.GRCz10.dna.toplevel.fa.gz"
echo
echo "Please be patient while I build the zebrafish BBMap database in your current directory..."
rm -rf BBMap
mkdir BBMap
bbmap.sh k=7 path=BBMap/Danio_rerio.GRCz10.dna.toplevel ref=Danio_rerio.GRCz10.dna.toplevel.fa.gz 2> BBMap/bbmap_build.log

echo Done.
