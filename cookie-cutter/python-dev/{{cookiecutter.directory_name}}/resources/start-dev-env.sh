#!/bin/bash

set -x 

# Setups ssh keys that are mounted at ~/.ssh-localhost
mkdir -p ~/.ssh
cp -r ~/.ssh-localhost/* ~/.ssh 
chmod 700 ~/.ssh 
chmod 600 ~/.ssh/*

cd ~/workspace

# setup the pre-commit hook for black
pre-commit install 

# Check if there is a local customization file
CUSTOMIZATION_SCRIPT="/env-files/customize-dev-env.sh"
if [ -f $CUSTOMIZATION_SCRIPT ] ; then
    source $CUSTOMIZATION_SCRIPT
fi

while sleep 1000; do :; done