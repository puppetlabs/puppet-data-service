#!/bin/bash
set -e

# Inputs

PE_VERSION="2021.4.0"
PLATFORM="el-8"

# Pre-requisites

mkdir /workspace
curl -o /workspace/pe.tar.gz "https://s3.amazonaws.com/pe-builds/released/${PE_VERSION}/puppet-enterprise-${PE_VERSION}-${PLATFORM}-x86_64.tar.gz"

mkdir /workspace/pe
tar -C /workspace/pe -xzf /workspace/pe.tar.gz --strip-components 1

cat > /etc/yum.repos.d/pe.repo <<EOF
[pe]
name=Puppet, Inc. PE Packages $releasever - $basearch
baseurl=file:///workspace/pe/packages/${PLATFORM}-x86_64
enabled=True
gpgcheck=1
gpgkey=file:///workspace/pe/packages/GPG-KEY-puppet
        file:///workspace/pe/packages/GPG-KEY-puppet-2025-04-06
proxy=
EOF

# Continue the process

yum groupinstall -y 'Development Tools'

yum install -y puppet-agent pe-puppet-enterprise-release pe-postgresql11-devel

git clone https://github.com/puppetlabs/puppet-data-service.git

cd puppet-data-service

make clean
make rpm


