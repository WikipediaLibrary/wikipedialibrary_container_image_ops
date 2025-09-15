# Use an obsolete base image for compatibility
FROM quay.io/wikipedialibrary/debian:buster-slim AS perl_build

# The last version that supports variable-width negative look behind
ENV PERL_VERSION=5.32.1

# Use the archive repositories
RUN find /etc/apt -type f -print0 -name "*.list" | xargs -0 sed -i 's/deb\.debian\.org/archive.debian.org/g'

# Base dependencies; split out to create cachable layer.
RUN apt update; \
    apt install -y \
    build-essential \
    gcc \
    wget ; \
    apt clean ; \
# Fetch, build, and install perl into /opt
    wget https://www.cpan.org/src/5.0/perl-${PERL_VERSION}.tar.gz ; \
    tar -xvf perl-${PERL_VERSION}.tar.gz ; \
    cd perl-${PERL_VERSION} ; \
    ./Configure -des -Dprefix=/opt/perl ; \
    make && make test && make install

# Copy perl only into a new slim image
FROM quay.io/wikipedialibrary/debian:buster-slim
COPY --from=perl_build /opt/perl /opt/perl

ENTRYPOINT ["/opt/perl/bin/perl"]
