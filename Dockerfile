ARG REGISTRY
ARG REPOSITORY
ARG TAG

FROM ${REGISTRY}/${REPOSITORY}:${TAG} AS mirror

FROM mirror AS update

RUN if [ -x "$(command -v apk)" ]; then apk --no-cache upgrade; \
  elif [ -x "$(command -v apt)" ]; then apt update && apt upgrade -y; rm -rf /var/lib/apt/lists/*; \
fi
