#!/usr/bin/env bash
shopt -s nullglob

function execute() {
  for dir in quay.io/wikipedialibrary/*/
  do
    # Drop trailing /
    repository=${dir::length-1}
    echo $repository
    tag=latest
    docker build \
      --tag ${repository}:${tag} \
      ${repository}
    docker push ${repository}:${tag}
  done
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
  execute
fi

