# Container image that runs your code
FROM  ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN  apt-get update \
  && apt-get -y install \
       software-properties-common \
       apt-utils \
  && add-apt-repository -y ppa:git-core/ppa \
  && apt-get update \
  && apt-get -y install \
       build-essential \
       curl \
       git \
       make \
       sudo \
  && rm -rf /var/lib/apt/lists/* \
  && curl -LO https://go.dev/dl/go1.18.1.linux-amd64.tar.gz \
  && rm -rf /usr/local/go \
  && tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/bin/go \
  && rm go1.18.1.linux-amd64.tar.gz
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
