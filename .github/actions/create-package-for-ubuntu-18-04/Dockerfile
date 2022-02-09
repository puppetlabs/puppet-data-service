# Container image that runs your code
FROM  ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN \
  apt-get update \
  apt-get install -y curl
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
