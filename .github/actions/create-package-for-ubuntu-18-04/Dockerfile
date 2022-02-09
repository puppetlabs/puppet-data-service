# Container image that runs your code
FROM  public.ecr.aws/lts/ubuntu:18.04_stable
RUN \
  apt install -y curl
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
