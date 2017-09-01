#!/bin/sh

set -x

echo "Starting ec2-user at-client bootstrap"

cd ~

cd sandbox

os=`uname -s`
case $os in
    Linux)
        MAKE=make
        nproc=`getconf _NPROCESSORS_ONLN`
        ;;
    FreeBSD)
        MAKE=gmake
        nproc=`getconf NPROCESSORS_ONLN`
        ;;
esac
npar=$(expr $nproc + 1)

git clone https://github.com/braddr/dotfiles
(cd dotfiles; $MAKE)

mywhich=`which timelimit`
if [ $? -ne 0 ]; then
    git clone https://github.com/braddr/timelimit
    (cd timelimit; $MAKE; sudo $MAKE install)
fi

setuprelease()
{
    case $os in
        Linux)
            curl -SL http://downloads.dlang.org/releases/2.x/2.068.2/dmd.2.068.2.linux.zip > dmd.2.068.2.linux.zip
            unzip dmd.2.068.2.linux.zip
            mv dmd2/* .
            rmdir dmd2
            ;;
        FreeBSD)
            curl -SL http://downloads.dlang.org/releases/2.x/2.068.2/dmd.2.068.2.freebsd-32.zip > dmd.2.068.2.freebsd-32.zip
            curl -SL http://downloads.dlang.org/releases/2.x/2.068.2/dmd.2.068.2.freebsd-64.zip > dmd.2.068.2.freebsd-64.zip
            unzip -o dmd.2.068.2.freebsd-32.zip
            unzip -o dmd.2.068.2.freebsd-64.zip
            mv dmd2/freebsd .
            mv dmd2/src .
            rm -rf dmd2
            ;;
    esac
}


git clone https://github.com/braddr/at-client
(cd at-client;
 mkdir -p release-build/install;
 cd release-build/install;
 setuprelease;
 cd ../..;
 echo "CPUS=$nproc" >> configs/`hostname`;
 echo "PARALLELISM=$npar" >> configs/`hostname`;
)

cat << EOF | crontab -
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin

@reboot (cd /home/ec2-user/sandbox/at-client; nohup ./src/run >> tester.log 2>&1 &)
EOF

ipv4=`curl --silent http://169.254.169.254/latest/meta-data/public-ipv4`
hname=`hostname`

cat << EOF | mail -s "new ec2 at host" braddr@puremagic.com
insert into build_hosts values (null, "$hname", "$ipv4", "braddr@puremagic.com", false, null, null);
select @@last_insert_id;
insert into build_host_projects select null, project_id, @@ from build_host_projects where host_id = 42;
insert into build_host_capabilities select null, @@, capability_id from build_host_capabilities where host_id = 42;
update build_hosts set enabled = true where id = @@;
EOF
