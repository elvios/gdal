# From ECW spec-file: (can hopefully resolve rpaths issue)
# "Needs to be built with:  QA_RPATHS=$[ 0x0001|0x002 ] rpmbuild -bb rpmbuild/SPECS/libecwj2.spec
# otherwise it complains about some rpaths - which we cannot see any problem with.. "
#
Name:           gdal
Version:        2.2.1
Release:        1%{?dist}
Summary:        GDAL

Group:          Libraries
License:        BSD
URL:            http://www.gdal.org/
Source0:        http://download.osgeo.org/gdal/%{version}/%{name}-%{version}.tar.gz
BuildRoot:      %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires:  libecwj2
BuildRequires:  giflib-devel
BuildRequires:  geos-devel
BuildRequires:  libjpeg-devel
BuildRequires:  libtiff-devel
BuildRequires:  libpng-devel
BuildRequires:  python-devel
#BuildRequires:  FileGDB_API
BuildRequires:  libgeotiff-devel
BuildRequires:  openjpeg2-devel
BuildRequires:  libcurl-devel

BuildRequires:  postgresql96
BuildRequires:  postgresql96-contrib
BuildRequires:  postgresql96-devel
BuildRequires:  postgresql96-libs
BuildRequires:  postgis2_96
BuildRequires:  postgis2_96-client
BuildRequires:  libpqxx-devel

BuildRequires:  SFCGAL-devel


#Requires:
Requires:       libecwj2
#Requires:      oracle-instantclient11.2-basic
#Requires:      oracle-instantclient11.2-devel
%description
GDAL Main files

%package devel
Summary:        GDAL library header files
Group:          Development/libraries
BuildRequires:  gdal

%description devel
GDAL header files

%prep
%setup -q

#Fix Python installation path
sed -i 's|setup.py install|setup.py install --root=%{buildroot}|' swig/python/GNUmakefile

%build
#fra gdal-rogue spec-fil
sed -i 's|@LIBTOOL@|%{_bindir}/libtool|g' GDALmake.opt.in

#--with-ecw=/opt/libecw \
#--with-fgdb=/usr/local \
#--with-static-proj4 \
#--disable-rpath \
#--with-python 

#https://trac.osgeo.org/gdal/wiki/BuildingOnUnix
#export ORACLE_HOME=/home/matt/instantclient_11_2 
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/matt/instantclient_11_2
#export PATH=$PATH:$ORACLE_HOME
#export NLS_LANG=American.America.WE8ISO8859P1 (this may not be essential) 
#--with-oci-include=/home/matt/instantclient_11_2/sdk/include
#--with-oci-lib=/home/matt/instantclient_11_2

        #--with-ecw=/opt/libecw \
        #--with-gif=internal \
        #--with-geos \
        #--with-geotiff \
        #--with-jpeg \
        #--with-libtiff=internal \
        #--with-png \
        #--with-pg \
        #--with-curl \
        #--with-openjpeg \



%configure \
        --with-curl=/opt/puppetlabs/puppet/bin/curl-config \
        --with-ecw=/opt/libecw \
        --with-geos=yes \
        --with-geotiff \
        --with-gif=internal \
        --with-jpeg \
        --with-libtiff=internal \
        --with-oci-lib=/opt/instantclient_12_2 \
        --with-openjpeg \
        --with-pg=/usr/pgsql-9.6/bin/pg_config \
        --with-png \




# -j [number] defines # of simultaneous jobs make will start
make -j72 %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}

#####fra gdal-rogue_minimal
%ifarch x86_64 # 32-bit libs go in /usr/lib while 64-bit libs go in /usr/lib64
%define lib_dir /usr/lib64
%else
%define lib_dir /usr/lib
%endif
mkdir -p %{buildroot}/%{lib_dir}/gdalplugins

%clean
rm -rf %{buildroot}
#rm -f /usr/local/lib/{libgeos*,libltidsdk*,libtbb*,liblti_lidar_dsdk*,liblaslib.so} && rm -f /usr/local/include/*.h && rm -rf /usr/local/include/{lidar,nitf}

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig


%files
%defattr(-, root, root, 0755)
%{_bindir}/*
%{_datadir}/gdal*
%{_libdir}/lib*
#%{_libdir}/gdal-%{version}.jar
%{_libdir}/pkgconfig/gdal.pc
%attr(755,root,root) /usr/include/internal_qhull_headers.h
%attr(755,root,root) /usr/share/GDALLogoBW.svg
%attr(755,root,root) /usr/share/GDALLogoColor.svg
%attr(755,root,root) /usr/share/GDALLogoGS.svg
%attr(755,root,root) /usr/share/LICENSE.TXT
%attr(755,root,root) /usr/share/compdcs.csv
%attr(755,root,root) /usr/share/coordinate_axis.csv
%attr(755,root,root) /usr/share/cubewerx_extra.wkt
%attr(755,root,root) /usr/share/datum_shift.csv
%attr(755,root,root) /usr/share/ecw_cs.wkt
%attr(755,root,root) /usr/share/ellipsoid.csv
%attr(755,root,root) /usr/share/epsg.wkt
%attr(755,root,root) /usr/share/esri_StatePlane_extra.wkt
%attr(755,root,root) /usr/share/esri_Wisconsin_extra.wkt
%attr(755,root,root) /usr/share/esri_extra.wkt
%attr(755,root,root) /usr/share/gcs.csv
%attr(755,root,root) /usr/share/gcs.override.csv
%attr(755,root,root) /usr/share/geoccs.csv
%attr(755,root,root) /usr/share/gml_registry.xml
%attr(755,root,root) /usr/share/gt_datum.csv
%attr(755,root,root) /usr/share/gt_ellips.csv
%attr(755,root,root) /usr/share/header.dxf
%attr(755,root,root) /usr/share/inspire_cp_BasicPropertyUnit.gfs
%attr(755,root,root) /usr/share/inspire_cp_CadastralBoundary.gfs
%attr(755,root,root) /usr/share/inspire_cp_CadastralParcel.gfs
%attr(755,root,root) /usr/share/inspire_cp_CadastralZoning.gfs
%attr(755,root,root) /usr/share/netcdf_config.xsd
%attr(755,root,root) /usr/share/nitf_spec.xml
%attr(755,root,root) /usr/share/nitf_spec.xsd
%attr(755,root,root) /usr/share/ogrvrt.xsd
%attr(755,root,root) /usr/share/osmconf.ini
%attr(755,root,root) /usr/share/ozi_datum.csv
%attr(755,root,root) /usr/share/ozi_ellips.csv
%attr(755,root,root) /usr/share/pci_datum.txt
%attr(755,root,root) /usr/share/pci_ellips.txt
%attr(755,root,root) /usr/share/pcs.csv
%attr(755,root,root) /usr/share/pcs.override.csv
%attr(755,root,root) /usr/share/prime_meridian.csv
%attr(755,root,root) /usr/share/projop_wparm.csv
%attr(755,root,root) /usr/share/ruian_vf_ob_v1.gfs
%attr(755,root,root) /usr/share/ruian_vf_st_uvoh_v1.gfs
%attr(755,root,root) /usr/share/ruian_vf_st_v1.gfs
%attr(755,root,root) /usr/share/ruian_vf_v1.gfs
%attr(755,root,root) /usr/share/s57agencies.csv
%attr(755,root,root) /usr/share/s57attributes.csv
%attr(755,root,root) /usr/share/s57attributes_aml.csv
%attr(755,root,root) /usr/share/s57attributes_iw.csv
%attr(755,root,root) /usr/share/s57expectedinput.csv
%attr(755,root,root) /usr/share/s57objectclasses.csv
%attr(755,root,root) /usr/share/s57objectclasses_aml.csv
%attr(755,root,root) /usr/share/s57objectclasses_iw.csv
%attr(755,root,root) /usr/share/seed_2d.dgn
%attr(755,root,root) /usr/share/seed_3d.dgn
%attr(755,root,root) /usr/share/stateplane.csv
%attr(755,root,root) /usr/share/trailer.dxf
%attr(755,root,root) /usr/share/unit_of_measure.csv
%attr(755,root,root) /usr/share/vdv452.xml
%attr(755,root,root) /usr/share/vdv452.xsd
%attr(755,root,root) /usr/share/vertcs.csv
%attr(755,root,root) /usr/share/vertcs.override.csv


%files devel
%defattr(644,root,root,755)
#%doc _html/*
%attr(755,root,root) %{_bindir}/gdal-config
%attr(755,root,root) %{_libdir}/libgdal.so
%{_libdir}/libgdal.la
%{_includedir}/cpl_*.h
%{_includedir}/cplkeywordparser.h
%{_includedir}/gdal*.h
%{_includedir}/gvgcpfit.h
%{_includedir}/memdataset.h
%{_includedir}/ogr_*.h
%{_includedir}/ogrsf_frmts.h
%{_includedir}/rawdataset.h
%{_includedir}/thinplatespline.h
%{_includedir}/vrtdataset.h
#%{_mandir}/man1/gdal-config.1*

%changelog
* Mon Jul 10 2017 Elvis Flesborg <elfle@sdfe.dk> 2.2.1
- Upgrade to 2.2.1

* Wed Feb 08 2017 Jonas Lund Nielsen <jolni@sdfe.dk> 2.1.0
- Upgrade to 2.1.3
- Has unsolved issues with rpath in version 2.1.3
  Relates to configuring --with-ecw=/opt/libecw \

* Tue Nov 08 2016 Jonas Lund Nielsen <jolni@sdfe.dk> 2.0.0
- Upgrade to 2.1.2
- Has unsolved issues with rpath in version 2.12

* Wed Aug 14 2013 Jesper Kihlberg <jekih@gst.dk> 1.0.0
- Initial version

