#!/bin/bash

# This script is for testing the different flags, when building GDAL with
# all the different dependencies that we have.

dir="$1"
gdaldir="gdal-2.2.1"
outputdir="/tmp/GDAL/$dir"

curldir="/opt/puppetlabs/puppet/bin/curl-config"
ocidir=`pwd`"/../dependencies/instantclient_12_2"
openjpegdir=`pwd`"/../dependencies/openjpeg-2.1.0/install"
pgdir="/usr/pgsql-9.6"
pgbindir="$pgdir/bin"
pglibdir="$pgdir/lib"

dirspecific=""

export ORACLE_HOME=$ocidir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME
export PATH=$PATH:$ORACLE_HOME

if [ -z $dir ]
then
    echo "Error: missing parameter 1"
    exit 100
fi


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
    dirspecific="--with-curl=$curldir $dirspecific"
fi


if [ "$dir" == "all" ] || [ "$dir" == "ecw" ]
then
    # This needs to be a special version of ecw.
    # We have it in the geodata repo.
    sudo yum install libecwj2
    dirspecific="--with-ecw=/opt/libecw $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "geos" ]
then
    dirspecific="--with-geos=yes $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "geotiff" ]
then
    dirspecific="--with-geotiffs $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "gif" ]
then
    dirspecific="--with-gif=internal $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "jpeg" ]
then
    dirspecific="--with-jpeg $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "libtiff" ]
then
    dirspecific="--with-libtiff=internal $dirspecific"
fi



if [ "$dir" == "all" ] || [ "$dir" == "oci" ]
then
    #dirspecific="--with-oci=/usr/lib/oracle/11.2/client64 --with-oci-include=/usr/include/oracle/11.2/client64 --with-oci-lib=/usr/lib/oracle/11.2/client64 $dirspecific"
    dirspecific="--with-oci-lib=$ocidir $dirspecific"
fi





if [ "$dir" == "all" ] || [ "$dir" == "openjpeg" ]
then
    dirspecific="--with-openjpeg=$openjpegdir $dirspecific"
fi


if [ "$dir" == "all" ] || [ "$dir" == "pg" ]
then
    #dirspecific="--with-pg=$pgbindir/pg_config PG_LIB=$pglibdir $dirspecific"
    dirspecific="--with-pg=$pgbindir/pg_config $dirspecific"
fi


if [ "$dir" == "all" ] || [ "$dir" == "png" ]
then
    dirspecific="--with-png $dirspecific"
fi


if [ "$2" == "--print-flags" ]
then
    echo "$dirspecific"
    exit
fi


# Actually configuring, making, and installing

./configure --prefix=$outputdir $dirspecific

if [ "$2" == "--only-configure" ]
then
    exit
fi


make -j72
make install
"$outputdir"/bin/gdalinfo --formats
