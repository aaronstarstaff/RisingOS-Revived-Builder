#!/bin/bash bash
set -e
cd /home/arman/rising-ci

source build/envsetup.sh
riseup ${CODENAME} ${TYPE}
rise sb
