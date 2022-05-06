# Container image that runs your code
FROM almalinux:8
RUN  yum -y groupinstall 'Development Tools' \
  && yum -y install git sudo \
  && yum -y clean all \
  && rm -rf /var/cache \
  && curl -LO https://go.dev/dl/go1.18.1.linux-amd64.tar.gz \
  && rm -rf /usr/local/go \
  && tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/bin/go \
  && rm go1.18.1.linux-amd64.tar.gz

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
