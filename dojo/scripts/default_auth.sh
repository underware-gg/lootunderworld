#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

echo "Authorizing models..."

export WORLD_ADDRESS="0x592275900516a2e313cb6a85324566c9f4265b21f5a0afa5adaf890d2d9ea0e";

# enable system -> model authorizations
MODELS=("Chamber" "Map" "State" "Tile" )
for model in ${MODELS[@]}; do
    sozo auth writer --world $WORLD_ADDRESS $model 0x1b0e6d71161f6379a25df22d87dac58f81ac2852c3497d9fad19d6fecacfc3
done


echo "Default authorizations have been successfully set."