ARG REGISTRY
ARG REPOSITORY
ARG TAG

FROM ${REGISTRY}/${REPOSITORY}:${TAG} AS mirror

FROM mirror AS update

RUN \
if [ -x "$(command -v apk)" ]; then apk --no-cache upgrade; \
elif [ -x "$(command -v apt)" ]; then apt update && apt upgrade -y; rm -rf /var/lib/apt/lists/*; \
fi; \
if [ -x "$(command -v pip3)" ] && [ -x "$(command -v python)" ]; then \
    pip3 --disable-pip-version-check list --outdated --format=json | python -c \
    "from json import loads; from sys import stdin; input = stdin.read(); pip_list = '[]' if input == '' else input; print('\n'.join([x['name'] for x in loads(pip_list)]))" \
    | xargs --no-run-if-empty -n1 pip3 install --root-user-action=ignore --upgrade --no-cache-dir --no-compile; \
fi
