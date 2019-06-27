# Python Remote Debugging
A template that can be used to demonstrate remote debugging on Kubernetes using Skaffold and Python.

# Prerequisites
Install skaffold v0.25
Install VSCode 
Install kubectl

# Configure
Use gcloud to configure kubectl credentials

```
gcloud container clusters get-credentials servicebroker --zone europe-west2-a --project tipinfra-01
```

```
export PIPENV_VENV_IN_PROJECT=1
pipenv install 
```

# Getting Started (create .env)
Create a .env file and add some values to it.
```
# This is the registry the image is going to be published to 
export REPOSITORY_PATH=eu.gcr.io/hutoma-backend/skaffold

# This is the version tag of the image
export SEMVER=0.0.1

# This is for local docker debugging 
export DEBUGGER=True
export WAIT=True
```

## Build and Publish the Image
Use the ./build-deploy.sh script to build and publish the image the configured registry.

```
./build_deploy.sh --action=publish --debug

```

This will use Docker to build the image and publish.  You will need to ensure that your docker credentials are correctly configured to use gcloud for auth. 

# Running and Debugging  
Use ./build-deploy.sh to build, publish, run and debug the container. 

```
./build_deploy.sh --action=dev --debug
./build_deploy.sh --action=deploy --debug
./build_deploy.sh --action=delete --debug
```

It will port-forward 5876 to localportso you can use VSCode's attach to remote python to single step debug. 
 
# Helm Deploy 

Dry run test deploy 
```
helm install ./k8s/pyk8s-remotedebug-chart --name pyk8s-remotedebug-v1 --dry-run --debug --values ./k8s/values.yaml
```

```
helm delete pyk8s-remotedebug --purge
```