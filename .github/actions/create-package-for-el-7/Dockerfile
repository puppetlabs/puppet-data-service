# Container image that runs your code
FROM quay.io/centos/centos:7
RUN \
  yum -y groupinstall 'Development Tools' && \
  yum -y install sudo epel-release && \
  yum -y install golang && \
  yum -y clean all && \
  rm -rf /var/cache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]
