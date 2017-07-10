#!/bin/bash

icdir=`pwd`"/../dependencies/instantclient_12_2"

# Unzipping all the instant client zip files
for i in `ls "$icdir"/zips`
do
    unzip "$icdir"/zips/"$i" -d ../dependencies
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
    
tar xvf gdal-2.2.1.tar.xz

# Installing all the dependencies
sudo yum install \
    @development \
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



# Installing development tools
sudo yum mark install "Development Tools"
sudo yum mark convert "Development Tools"
sudo yum groupinstall "Development Tools"
