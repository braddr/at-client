#!/bin/bash

instance_type=`curl --silent http://169.254.169.254/latest/meta-data/instance-type/`

echo "Fetching $instance_type bootstrap script"
aws --region us-west-2 s3 cp s3://client-bootstrap.auto-tester.puremagic.com/$instance_type-bootstrap.sh /var/tmp/$instance_type-bootstrap.sh
chmod u+x /var/tmp/$instance_type-bootstrap.sh

echo "Executing $instance_type bootstrap script"
/var/tmp/$instance_type-bootstrap.sh $instance_type

