#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 

IMAGE_NAME=eu.gcr.io/tipinfra-01/skaffold/pythonremotedebug:0.0.1
docker build -t ${IMAGE_NAME} .
ID=$(docker run -d --rm -e DEBUGGER=True -e WAIT=True -p 5678:5678 ${IMAGE_NAME})
echo "docker logs ${ID}"
echo "docker stop ${ID}"
echo "docker exec -it ${ID} /bin/bash"