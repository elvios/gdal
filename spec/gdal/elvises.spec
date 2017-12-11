Name:		elvises
Version:	1
Release:	1%{?dist}
Summary:	Er et test-spec-script-fil-program

License:	BSD
Group:		Libraries
URL:		http://dr.dk
Source0:	src.tar.gz
BuildRoot:  /tmp/elvisestest


%description


%prep
%setup -q


%build
%configure


%install


%files
%doc
/usr/share/elvisestest.txt
%{_bindir}/hello.py


%changelog

