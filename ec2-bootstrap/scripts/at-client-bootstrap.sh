#!/bin/sh

instance_type=`curl --silent http://169.254.169.254/latest/meta-data/instance-type/`
os=`uname -s`

echo "Fetching $os $instance_type bootstrap script"
aws --region us-west-2 s3 cp s3://client-bootstrap.auto-tester.puremagic.com/$os-$instance_type-bootstrap.sh /var/tmp/$os-$instance_type-bootstrap.sh
chmod u+x /var/tmp/$os-$instance_type-bootstrap.sh

echo "Executing $os-$instance_type bootstrap script"
/var/tmp/$os-$instance_type-bootstrap.sh $instance_type

