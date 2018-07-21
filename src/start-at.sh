#!/usr/bin/env bash

cd ~/sandbox/at-client

./src/do_daily_maintenance.sh
rm -rf pull-*
rm -rf master-*

nohup ./src/run >> tester.log 2>&1 &
