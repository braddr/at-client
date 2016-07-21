#!/bin/bash

aws --profile at s3 cp at-client-bootstrap.sh          s3://client-bootstrap.auto-tester.puremagic.com/
aws --profile at s3 cp c3.large-bootstrap.sh           s3://client-bootstrap.auto-tester.puremagic.com/
aws --profile at s3 cp c4.large-bootstrap.sh           s3://client-bootstrap.auto-tester.puremagic.com/
aws --profile at s3 cp ec2-user-at-client-bootstrap.sh s3://client-bootstrap.auto-tester.puremagic.com/
