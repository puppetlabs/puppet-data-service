# Container image that runs your code
FROM quay.io/centos/centos:7
RUN  yum -y update ca-certificates \
  && yum -y install epel-release \
  && yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm \
  && yum -y install sudo git \
  && yum -y groupinstall 'Development Tools' \
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
