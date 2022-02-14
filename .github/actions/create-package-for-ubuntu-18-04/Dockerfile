# Container image that runs your code
FROM  ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN add-apt-repository -y ppa:longsleep/golang-backports; apt-get update ; apt-get -y install curl wget make build-essential apt-utils golang-go sudo
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
