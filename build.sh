#!/bin/bash bash
set -e
cd /home/arman/rising-ci

source build/envsetup.sh

riseup ${CODENAME} ${TYPE}

if [ "$SIGNING" == "normal" ]; then
    rise b
elif [ "$SIGNING" == "normal-fastboot" ]; then
    rise fb
elif [ "$SIGNING" == "full" ]; then
    rise sb
fi
