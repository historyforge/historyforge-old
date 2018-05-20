#!/usr/bin/env bash

# make sure we have up-to-date packages
apt-get update

## vagrant grub-pc fix from: https://gist.github.com/jrnickell/6289943
# parameters
echo "grub-pc grub-pc/kopt_extracted boolean true" | debconf-set-selections
echo "grub-pc grub2/linux_cmdline string" | debconf-set-selections
echo "grub-pc grub-pc/install_devices multiselect /dev/sda" | debconf-set-selections
echo "grub-pc grub-pc/install_devices_failed_upgrade boolean true" | debconf-set-selections
echo "grub-pc grub-pc/install_devices_disks_changed multiselect /dev/sda" | debconf-set-selections
# vagrant grub fix
dpkg-reconfigure -f noninteractive grub-pc

# upgrade all packages
#apt-get upgrade -y

cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p643.tar.gz
tar -xvzf ruby-2.0.0-p643.tar.gz
cd ruby-2.0.0-p643/
./configure --prefix=/usr/local
make
make install

# install packages as explained in INSTALL.md
apt-get install -y libgmp-dev \
    postgresql-9.3 postgresql-server-dev-all postgresql-contrib postgresql-9.3-postgis-scripts \
    build-essential git-core \
    libxml2-dev libxslt-dev imagemagick libmapserver1 gdal-bin libgdal-dev ruby-mapscript nodejs

#ruby gdal needs the build Werror=format-security removed currently
sed -i 's/-Werror=format-security//g' /usr/lib/ruby/1.9.1/x86_64-linux/rbconfig.rb

# gem1.9.1 install bundle
