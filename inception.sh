#!/bin/bash -e

ROOT=Central-IT
PROJECTS_ROOT=infra-projects
IAM_ROOT=infra-iam
NETWORK_ROOT=infra-network

function Usage()
{
    case "${@}"
    in
        ("addProject") echo "inception.sh addProject PROJECT_NAME" ;;
        ("addModule")  echo "inception.sh addTFModule MODULE_NAME" ;;
        ("addEnv")     echo "inception.sh addEnv PROJECT_NAME ENV_NAME" ;;
    esac
    exit 0
}

function init()
{
    rm -rf ${ROOT}
    mkdir -p ${ROOT}/{${PROJECTS_ROOT}/{ansible,packer,terraform/modules},${NETWORK_ROOT}/{ansible,terraform/modules},${IAM_ROOT}/terraform/modules}
    show
}

function addProject()
{
    if [ -z $1 ]; then
        Usage "addProject"
    fi
    mkdir -p  ${ROOT}/${PROJECTS_ROOT}/{ansible,packer,terraform}/$1/{production,stage,dev}
    touch ${ROOT}/${PROJECTS_ROOT}/terraform/$1/{production,stage,dev}/{main.tf,variable.tf,output.tf,terraform.tfvars}
    touch ${ROOT}/${PROJECTS_ROOT}/ansible/$1/{production,stage,dev}/ansible.cfg
    mkdir -p ${ROOT}/${PROJECTS_ROOT}/ansible/$1/{production,stage,dev}/playbooks
    show
}

function addTFModule()
{
    if [ -z $1 ]; then
        Usage "addModule"
    fi
    mkdir -p ${ROOT}/${PROJECTS_ROOT}/terraform/modules/$1
    show
}

function addEnv()
{
    if [ -z $1 ]; then
        Usage "addEnv"
    fi
    if [ -z $2 ]; then
        Usage "addEnv"
    fi

    if [ -d $1]; then
        echo "$1" does not exists
        exit 0
    fi
    mkdir -p ${ROOT}/${PROJECTS_ROOT}/terraform/$1/$2
    touch ${ROOT}/${PROJECTS_ROOT}/terraform/$1/$2/{main.tf,variable.tf,output.tf,terraform.tfvars}
    show
}

function show()
{
    tree ${ROOT}
}


case "${1}"
in
    ("init") init ;;
    ("addProject") addProject $2 ;;
    ("addTFModule") addTFModule $2 ;;
    ("addEnv") addEnv $2 $3;;

    (*) echo "$0 [ init | addProject | addTFModule | addEnv ]" ;;
esac
