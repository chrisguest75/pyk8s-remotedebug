#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_PATH=${0:A}
readonly SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if [ ! -z "${DEBUG_ENVIRONMENT}" ];then 
    env
    export
fi
#****************************************************************************
#** Print out usage
#****************************************************************************

function help() {
    local EXITCODE=0

    cat <<- EOF
usage: $SCRIPT_NAME options

Build, Publish, Deploy the container.

OPTIONS:
    -a --action              [publish|dev|deploy]
    
    -h --help                show this help

Examples:
    $SCRIPT_NAME --action=publish 

EOF

    return ${EXITCODE}
}

#****************************************************************************
#** Check gcloud is available and configured
#****************************************************************************

function check_gcloud() (
    local GCLOUDCONFIGURATION=$1
    local GCPPROJECT=$2
    local EXITCODE=0

    if ! which gcloud; then 
        echo "[FAILED] Could not find Google Cloud SDK tool 'gcloud'";
        EXITCODE=1
    else
        if [[ -z ${GCLOUDCONFIGURATION} ]];then
            GCLOUDCONFIGURATION=
        fi
        if ! gcloud ${GCLOUDCONFIGURATION} --format=json projects list | jq ".[].projectId == \"${GCPPROJECT}\"" | grep "true"; then
            echo "[FAILED] Could not find project '${GCPPROJECT}' in '${GCLOUDCONFIGURATION}'";
            EXITCODE=1
        fi
    fi

    return ${EXITCODE}
)

#****************************************************************************
#** Main script 
#****************************************************************************

function main() {
    local EXITCODE=0
    local DEBUG=false  
    local SKAFFOLD_DEBUG=         

    for i in "$@"
    do
    case $i in
        -v=*|--version=*)
            local -r VERSION="${i#*=}"
            shift # past argument=value
        ;;
        -a=*|--action=*)
            local -r ACTION="${i#*=}"
            shift # past argument=value
        ;;           
        --debug)
            set -x
            local -r DEBUG=true   
            SKAFFOLD_DEBUG="--verbosity debug"          
            shift # past argument=value
        ;;   
        -h|--help)
            local -r HELP=true            
            shift # past argument=value
        ;;
        *)
            echo "Unrecognised ${i}"
        ;;
    esac
    done    

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

    if [ "${HELP}" = true ] ; then
        EXITCODE=1
        help
    else
        if [ "${ACTION}" ]; then
            case "${ACTION}" in
                help)
                    help
                ;;
                publish)
                    skaffold build --profile=publish --default-repo ${REPOSITORY_PATH} ${SKAFFOLD_DEBUG}
                ;;
                dev)
                    skaffold dev --profile=testk8s --default-repo ${REPOSITORY_PATH} ${SKAFFOLD_DEBUG}
                ;;
                deploy)
                    skaffold deploy --profile=testk8s --default-repo ${REPOSITORY_PATH} ${SKAFFOLD_DEBUG}
                ;;
                delete)
                    skaffold delete --profile=testk8s --default-repo ${REPOSITORY_PATH} ${SKAFFOLD_DEBUG}
                ;;                
                docker)
                    IMAGE_NAME=${REPOSITORY_PATH}/pythonremotedebug:${SEMVAR}
                    docker build -t ${IMAGE_NAME} .

                    ID=$(docker run -d --rm -e DEBUGGER=True -e WAIT=True -p 5678:5678 ${IMAGE_NAME})

                    echo "docker logs ${ID}"
                    echo "docker stop ${ID}"
                    echo "docker exec -it ${ID} /bin/bash"                   
                ;;
                *)
                    echo "Unrecognised ${ACTION}"; 
                ;;
            esac
        else
            EXITCODE=1
            echo "No action specified use --action=<action>"
        fi
    fi
    return ${EXITCODE}
}

main "$@"


