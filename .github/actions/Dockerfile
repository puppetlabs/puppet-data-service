# Container image that runs your code
FROM centos:8

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY make-pds-rpm.sh /make-pds-rpm.sh

# Executes `make-pds-rpm.sh` when the Docker container starts up
CMD ["/make-pds-rpm.sh"]
