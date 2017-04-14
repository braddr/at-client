#!/bin/sh

aws --profile at s3 cp scripts/at-client-bootstrap.sh          s3://client-bootstrap.auto-tester.puremagic.com/at-client-bootstrap.sh
aws --profile at s3 cp scripts/ec2-user-at-client-bootstrap.sh s3://client-bootstrap.auto-tester.puremagic.com/ec2-user-at-client-bootstrap.sh

# delete eventually
aws --profile at s3 cp scripts/c3.large-bootstrap.sh           s3://client-bootstrap.auto-tester.puremagic.com/c3.large-bootstrap.sh
aws --profile at s3 cp scripts/c4.large-bootstrap.sh           s3://client-bootstrap.auto-tester.puremagic.com/c4.large-bootstrap.sh

# linux platforms
aws --profile at s3 cp scripts/Linux-c3.large-bootstrap.sh     s3://client-bootstrap.auto-tester.puremagic.com/Linux-c3.large-bootstrap.sh
aws --profile at s3 cp scripts/Linux-c4.large-bootstrap.sh     s3://client-bootstrap.auto-tester.puremagic.com/Linux-c4.large-bootstrap.sh

# freebsd platforms
aws --profile at s3 cp scripts/FreeBSD-c3.large-bootstrap.sh   s3://client-bootstrap.auto-tester.puremagic.com/FreeBSD-c3.large-bootstrap.sh

