#!/usr/bin/env bash

function execute() {
  while read image
  do
    registry=${1}
    target=${2}
    IFS=:
    read -ra ref <<< ${image}
    repository=${ref[0]}
    source_tag=${ref[1]}
    case ${target} in
        mirror)
          dest_tag=${source_tag}
          ;;
        update)
          dest_tag="${source_tag}-updated"
          ;;
        *)
          exit 1
          ;;
    esac
    docker build \
        --build-arg REGISTRY=${registry} \
        --build-arg REPOSITORY=${repository} \
        --build-arg TAG=${source_tag} \
        --target ${target} \
        --tag quay.io/wikipedialibrary/${repository}:${dest_tag} \
        .
    docker push quay.io/wikipedialibrary/${repository}:${dest_tag}
  done <${1}/PARENT_IMAGES
}

# login if we have container registry credentials
if [ -n "${quaybot_username+isset}" ] && [ -n "${quaybot_password+isset}" ]
then
  # login to quay.io
  echo "$quaybot_password" | docker login quay.io -u "$quaybot_username" --password-stdin
  execute ${1} ${2}
  # logout from quay.io
  docker logout quay.io
else
  execute ${1} ${2}
fi

