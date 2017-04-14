#!/bin/sh

# args:
#   0 = app name
#   1 = instance size

echo "Starting $1 at-client bootstrap"

# update to current amazon inux
yum -y update

# install basic tools
yum -y install vim patch screen make git curl mailx
yum -y install glibc-devel.i686 libcurl.i686 libcurl-devel gcc gcc-c++ gdb libstdc++48-devel libstdc++48.i686

# fix libcurl-devel to include i386 symlinks
(cd /usr/lib; ln -s libcurl.so.4.3.0 libcurl.so)

# gcc build dependencies
yum -y install dejagnu libmpc-devel flex bison mpfr-devel gmp-devel

# format and setup disks
# NOTE: not currently adding any disks to c4.large instances
# umount /dev/xvdb /dev/xvdc
# echo "/dev/xvdc /media/ephemeral1 auto defaults,nofail,comment=cloudconfig 0 2" >> /etc/fstab
# if [ ! -d /media/ephemeral0 ]; then
#     mkdir /media/ephemeral0
# fi
# if [ ! -d /media/ephemeral1 ]; then
#     mkdir /media/ephemeral1
# fi
# mkfs -F -t ext4 /dev/xvdb
# mkfs -F -t ext4 /dev/xvdc
# mount -a

# allow ec2-user to sudo without a tty
echo "Defaults:ec2-user !requiretty" > /etc/sudoers.d/9999-ec2-user-no-requiretty

mkdir /home/ec2-user/sandbox
chown ec2-user:ec2-user /home/ec2-user/sandbox

aws --region us-west-2 s3 cp s3://client-bootstrap.auto-tester.puremagic.com/ec2-user-at-client-bootstrap.sh /var/tmp/ec2-user-at-client-bootstrap.sh
chmod a+x /var/tmp/ec2-user-at-client-bootstrap.sh
runuser -u ec2-user /var/tmp/ec2-user-at-client-bootstrap.sh

reboot

