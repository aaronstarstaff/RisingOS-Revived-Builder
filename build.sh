#!/bin/bash bash
set -e
cd /home/arman/rising-ci

source build/envsetup.sh

lunch lineage_${CODENAME}-bp1a-${TYPE}
mka bacon
