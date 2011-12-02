#!/bin/sh

if ! [ -d /package ]; then
    mkdir /package
fi
cd /package

# get daemontools
wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz
tar xvfz daemontools-0.76.tar.gz
rm -f daemontools-0.76.tar.gz
cd admin/daemontools-0.76

# get patch for daemontools
wget http://www.nslabs.jp/archives/daemontools-0.76-q1.diff

patch -s -p1 <daemontools-0.76-q1.diff

# make & install
./package/install

isActive=`ps cax |grep svscanboot |awk '{ print $1; }'`
if [ "$isActive" = "" ]; then
    
    # create upstart script
cat >/etc/init/svscanboot.conf <<'__EOD__'
start on startup
respawn
exec /command/svscanboot start
__EOD__
fi

echo -n "Would you like reboot now [y/N]? "
read res
if [ "$res" = "y" ]; then
    reboot
fi
exit 0
 
