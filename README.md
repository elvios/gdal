Requirements
============

Install the following:

- @development (in repo)
- SFCGAL-devel (in repo)

- openjpeg2.0 (from source)
    - cmake (in repo)

- Oracle instant client (in this project)

- postgresql96
- postgresql96-contrib
- postgresql96-devel
- postgresql96-libs
- postgresql96-server
- postgis2_96
- postgis2_96-client
- libpqxx-devel



GDAL already has built in libraries for the following:
- libz
- libtiff
- libgeotiff
- libpng
- libgif
- libjpeg

File structure
==============

- dependencies
    - Oracle instant client unzipped and ready
    - OpenJpeg source code, must be compiled first
- compile
    - gdal-2.2.1.tar.xz (The source code)
    - gdal-2.2.1 (Dir with the untouched source code)
    - The compile.sh script
    - Directories for the different tests
        - all for the one with all flags
        - none for the one with no flags

There is a directory for every flag we need to compile with. The `none` dir is
for the standard compilation, with no flags. The `all` is for the one with all
the flags.


Things to compile with
======================

- curl
- ecw
- geos
- geotiff
- gif
- jpeg
- libtiff
- openjpeg (jpeg2000)
- oracle (oci)
- png
- postgres


Curl
----

--with-curl=ARG

`ARG` needs to be the location of the file `curl-config`.
type `locate curl-config` to find out where it is. In this case, it was in
`/opt/puppetlabs/puppet/bin/curl-config`


ECW
---

--with-ecw=ARG

`ARG` needs to be the path to libecw.
Also, libecwj2 must be installed.
    * --disable-rpath



OCI Oracle GeoRaster Support
----------------------------

[1](https://community.oracle.com/thread/1130217?db=5)

1. Do not install the rpms. Unzip the zips in stead to an install dir
2. You only need these 3 packages - they will all unzip to the same dir:
    b. basic
    a. sdk
    c. sqlplus
3. Symbolic links to libocci.so and liblntsh.so
4. Symbolic link for every .so-file to new folder /installdir/lib/
5. ./configure --with-oci-lib=/installdir/ (It will automatically append /lib)




OpenJPEG (jpeg 2000 support)
----------------------------

Get the source code here: 
[2](https://github.com/uclouvain/openjpeg)

Project home page here:
[3](http://www.openjpeg.org/)


1. go to source dir
2. mkdir build install
3. cd build
4. cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=`pwd`/../install
5. make
6. sudo make install
7. sudo make clean



PG (PostgreSQL)
===============

This will need the package libpqxx-devel.


Links
=====

[List of formats available](http://www.gdal.org/formats_list.html)
