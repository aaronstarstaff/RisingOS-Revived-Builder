#!/bin/bash bash
set -e
cd /home/runner/rising-ci

source build/envsetup.sh
riseup ${CODENAME} ${TYPE}
rise sb
