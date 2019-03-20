#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 

#export TILLER_NAMESPACE=helm-tiller
if [ -f .env ]; then
    echo "Importing .env file"
    . .env
fi
if [ -z ${SEMVER} ]; then
    echo "SEMVER not defined"
fi 
if [ -z ${REPOSITORY_PATH} ]; then
    echo "REPOSITORY_PATH not defined"
fi
skaffold build --verbosity debug --profile=publish --default-repo ${REPOSITORY_PATH}
