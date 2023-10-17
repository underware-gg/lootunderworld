#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export WORLD_ADDRESS="0x9fcfa7f23017ca5bb2dceac67a405bf83639fea1d09c6027ee1cdfe573d33e";

# enable system -> component authorizations
COMPONENTS=("Position" "Moves" "Chamber" "Map" "State" "Tile" )

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component spawn --world $WORLD_ADDRESS
done

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component move --world $WORLD_ADDRESS
done

echo "Default authorizations have been successfully set."