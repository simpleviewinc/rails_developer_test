#!/usr/bin/env bash
YUM_FLAGS=$(echo "--setopt=tsflags=nodocs install -y")

yum -y --setopt=tsflags=nodocs update
yum $YUM_FLAGS centos-release-scl-rh sudo wget git git-core curl nano
yum $YUM_FLAGS pkg-config libxml2 libxml2-devel libxslt libxslt-devel
yum $YUM_FLAGS libpng libjpeg openssl ruby-devel zlib-devel which
yum $YUM_FLAGS openssh gcc gcc-c++ postgresql-devel icu make
yum $YUM_FLAGS https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum $YUM_FLAGS geos-devel ImageMagick ImageMagick-devel

yum clean all
