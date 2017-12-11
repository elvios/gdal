#!/bin/bash

# This script is to install all the dependencies for the compile.sh scipt

### ORACLE INSTANT CLIENT ###

# Setting the dir for the instant client
zipdir=`pwd`"/../dependencies/instantclient_12_2/zips"
optdir="/opt"
icdir="$optdir/instantclient_12_2"
sudo mkdir "$icdir"
sudo chown -R kfadm: "$icdir"

# Unzipping all the instant client zip files
for i in `ls "$zipdir"`
do
    unzip "$zipdir/$i" -d "$optdir"
done


# Fixing Instant Client - part 1 
# symlinking two library-files
sudo ln -s "$icdir"/libocci.so.12.1 "$icdir"/libocci.so
sudo ln -s "$icdir"/libclntsh.so.12.1 "$icdir"/libclntsh.so


# Fixing Instant Client - part 2
# Copying all the .so-files into a new dir, called `lib`
mkdir "$icdir"/lib

for sofile in `ls "$icdir"/*.so`
do
    sudo ln -s "$sofile" "$icdir"/lib
done
    

### GDAL SOURCE CODE ###

# Untarring the gdal source code
tar xvf gdal-2.2.1.tar.xz



### OTHER DEPENDENCIES ###


# Installing all the dependencies
sudo yum install \
    SFCGAL-devel \
    openjpeg2-devel \
    openjpeg2 \
    postgresql96 \
    postgresql96-contrib \
    postgresql96-devel \
    postgresql96-libs \
    postgresql96-server \
    postgis2_96 \
    postgis2_96-client \
    libpqxx-devel \
    libecwj2 \
    zlib-devel



# (Re-)Installing development tools
sudo yum group mark install "Development Tools"
sudo yum group mark convert "Development Tools"
sudo yum groupinstall "Development Tools"
