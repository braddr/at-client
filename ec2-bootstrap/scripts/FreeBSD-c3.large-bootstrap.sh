#!/bin/sh

set -x

# args:
#   0 = app name
#   1 = instance size

echo "Starting $1 at-client bootstrap"

chsh -s bash ec2-user

# create mount points
if [ ! -d /media ]; then
    mkdir /media
fi
if [ ! -d /media/ephemeral0 ]; then
    mkdir /media/ephemeral0
fi
if [ ! -d /media/ephemeral1 ]; then
    mkdir /media/ephemeral1
fi

# format and setup disks
disknum=0
for x in /dev/xbd*; do
    if [ $x = "/dev/xbd0" ]; then
        continue
    fi

    umount $x
    echo "$x /media/ephemeral$disknum ufs rw 0 2" >> /etc/fstab
    newfs $x
    mount $x

    disknum=$(($disknum + 1))
done

# allow ec2-user to sudo without a tty
echo "Defaults:ec2-user !requiretty" > /usr/local/etc/sudoers.d/9999-ec2-user-no-requiretty
echo "ec2-user ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers.d/9999-ec2-user-no-requiretty

mkdir /media/ephemeral0/sandbox
ln -s /media/ephemeral0/sandbox /home/ec2-user/sandbox
chown ec2-user:ec2-user /media/ephemeral0/sandbox
chown -h ec2-user:ec2-user /home/ec2-user/sandbox

aws --region us-west-2 s3 cp s3://client-bootstrap.auto-tester.puremagic.com/ec2-user-at-client-bootstrap.sh /var/tmp/ec2-user-at-client-bootstrap.sh
chmod a+x /var/tmp/ec2-user-at-client-bootstrap.sh
su - ec2-user -c "/var/tmp/ec2-user-at-client-bootstrap.sh"

