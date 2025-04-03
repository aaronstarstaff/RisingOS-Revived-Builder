#!/bin/bash bash
set -e
cd /home/arman/rising-ci

source build/envsetup.sh

lunch lineage_${CODENAME}-bp1a-${TYPE}

if [ "$SIGNING" == "normal" ]; then
    mka bacon
elif [ "$SIGNING" == "normal-fastboot" ]; then
    rise fb
elif [ "$SIGNING" == "full" ]; then
    rise sb
fi
