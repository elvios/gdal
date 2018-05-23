#!/bin/bash

# This script is for testing the different flags, when building GDAL with
# all the different dependencies that we have.
#
# For installing all the dependencies on RHEL run the install.sh-script.
#
# Usage: ./compile.sh dir [--only-configure]
# --only-configure will not install or compile the code. Only the config file.


### CONSTANTS ###


# These constants will rarely need editing
dir="$1"
#gdaldir="gdal-2.2.1"
gdaldir="gdal-2.3.0"
outputdir="/opt/gdal"
ocidir="/usr/lib/oracle/12.2"
#openjpegdir=`pwd`"/../dependencies/openjpeg-2.1.0/install"

# These constants will probably need editing
curldir="/opt/puppetlabs/puppet/bin/curl-config"
pgdir="/usr/pgsql-9.6"
pgbindir="$pgdir/bin"
pglibdir="$pgdir/lib"
pgincdir="$pgdir/include"


# This is the variable that holds the flags that is given to the `./configure`-command
flags=""


export ORACLE_HOME=$ocidir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
export PATH=$PATH:$ORACLE_HOME
export PG_LIB=$PG_LIB:$pglibdir
export PG_INC=$PG_INC:$pgincdir


if [ -z $dir ]
then
    echo "Error: missing parameter 1"
    exit 100
fi

#tar xvf gdal-2.2.1.tar.xz
tar xvf gdal-2.3.0.tar.xz

# Removing the test-compile-directory, if it exists
if [ -d "$outputdir" ]
then
    rm -r "$outputdir"
fi



# Removing the source code directory, and replacing with a clean one
if  [ -d "$dir/$gdaldir" ]
then
    rm -r "$dir/$gdaldir"
fi

cp -R "$gdaldir" "$dir/$gdaldir"



# Changing to that directory as new working directory
cd "$dir/$gdaldir"





# Specific arguments for the different dependencies

if [ "$dir" == "all" ] || [ "$dir" == "curl" ]
then
    # Needs some kind of dependency
    flags="--with-curl=$curldir $flags"
fi


if [ "$dir" == "all" ] || [ "$dir" == "ecw" ]
then
    # This needs to be a special version of ecw.
    # We have it in the geodata repo.
    flags="--with-ecw=/opt/libecw $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "geos" ]
then
    flags="--with-geos=yes $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "geotiff" ]
then
    flags="--with-geotiff $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "gif" ]
then
    flags="--with-gif=internal $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "jpeg" ]
then
    flags="--with-jpeg $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "libtiff" ]
then
    flags="--with-libtiff=internal $flags"
fi



if [ "$dir" == "all" ] || [ "$dir" == "oci" ]
then
    flags="--with-oci-lib=$ocidir $flags"
fi





if [ "$dir" == "all" ] || [ "$dir" == "openjpeg" ]
then
    # flags="--with-openjpeg=$openjpegdir $flags"
    flags="--with-openjpeg"
fi


if [ "$dir" == "all" ] || [ "$dir" == "pg" ]
then
    flags="--with-pg=$pgbindir/pg_config $flags"
fi


if [ "$dir" == "all" ] || [ "$dir" == "png" ]
then
    flags="--with-png $flags"
fi


if [ "$dir" == "all" ] || [ "$dir" == "sqlite3" ]
then
    flags="--with-sqlite3 $flags"
fi


if [ "$2" == "--print-flags" ]
then
    echo "$flags"
    exit
fi


### Actually configuring, making, and installing

./configure --prefix=$outputdir $flags

if [ "$2" == "--only-configure" ]
then
    exit
fi


make -j72
make install
"$outputdir"/bin/gdalinfo --formats
