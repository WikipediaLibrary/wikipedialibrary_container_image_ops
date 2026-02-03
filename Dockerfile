ARG REGISTRY=docker.io
ARG REPOSITORY=alpine
ARG TAG=latest

FROM ${REGISTRY}/${REPOSITORY}:${TAG} AS mirror

FROM mirror AS update

STOPSIGNAL SIGTERM

COPY pip_upgrade_outdated.py /opt/twl/bin/
RUN \
if [ -x "$(command -v apk)" ]; then \
	apk --no-cache upgrade; \
elif [ -x "$(command -v apt)" ]; then \
	apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && rm -rf /var/lib/apt/lists/*; \
fi; \
if [ -x "$(command -v python)" ]; then \
	/opt/twl/bin/pip_upgrade_outdated.py; \
fi
