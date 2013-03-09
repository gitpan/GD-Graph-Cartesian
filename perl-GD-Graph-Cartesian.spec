Name:           perl-GD-Graph-Cartesian
Version:        0.09
Release:        1%{?dist}
Summary:        Make cartesian graph using GD package
License:        perl
Group:          Development/Libraries
URL:            http://search.cpan.org/dist/GD-Graph-Cartesian/
Source0:        http://www.cpan.org/modules/by-module/GD/GD-Graph-Cartesian-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch
BuildRequires:  perl(ExtUtils::MakeMaker)
BuildRequires:  perl(Test::More)
BuildRequires:  perl(Path::Class)
BuildRequires:  perl(GD) >= 2.02
BuildRequires:  perl(List::MoreUtils)
BuildRequires:  perl(List::Util)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description
This is a wrapper around GD to place points and lines on a X/Y scater plot.

%prep
%setup -q -n GD-Graph-Cartesian-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc Changes LICENSE README
%{perl_vendorlib}/*
%{_mandir}/man3/*

%changelog
* Mon Mar 19 2012 Michael R. Davis (mdavis@stopllc.com) 0.07-1
- Specfile autogenerated by cpanspec 1.78.
