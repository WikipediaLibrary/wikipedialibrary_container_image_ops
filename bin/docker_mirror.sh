#!/usr/bin/env bash

function mirror() {
  # Loop through our images: pull from docker.io, retag, push to quay.io
  while read image
  do
    docker pull docker.io/library/${image}
    docker tag docker.io/library/${image} quay.io/wikipedialibrary/${image}
    docker push quay.io/wikipedialibrary/${image}
  done <data/BASE_IMAGES
}

# login if we have container registry credentials
if [ -n "${quaybot_username+isset}" ] && [ -n "${quaybot_password+isset}" ]
then
  # login to quay.io
  echo "$quaybot_password" | docker login quay.io -u "$quaybot_username" --password-stdin
  mirror
  # logout from quay.io
  docker logout quay.io
else
  mirror
fi

