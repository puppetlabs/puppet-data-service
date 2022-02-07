# Container image that runs your code
FROM quay.io/centos/centos:7
RUN \
  yum -y update ca-certificates && \
  yum -y install epel-release && \
  yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm && \
  yum -y install sudo golang git && \
  yum -y groupinstall 'Development Tools' && \
  yum -y clean all && \
  rm -rf /var/cache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
