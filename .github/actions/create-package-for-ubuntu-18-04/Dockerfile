# Container image that runs your code
FROM  ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update && \
  apt-get -y install software-properties-common && \
  apt-get -y install curl && \
  apt-get -y install make && \
  apt-get -y install build-essential && \
  apt-get -y install apt-utils && \
  apt-get -y install sudo && \
  add-apt-repository -y ppa:longsleep/golang-backports && \
  apt-get update && \
  apt-get -y install golang-go
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
