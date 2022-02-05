#!/bin/bash
set -e

# Inputs

PE_VERSION=${1:-2021.4.0}
PLATFORM=${PLATFORM:-el-7}
WORKDIR=${GITHUB_WORKSPACE:-/workspace}

# Pre-requisites

mkdir -p "${WORKDIR}"
curl -o "${WORKDIR}/pe.tar.gz" "https://s3.amazonaws.com/pe-builds/released/${PE_VERSION}/puppet-enterprise-${PE_VERSION}-${PLATFORM}-x86_64.tar.gz"

mkdir -p "${WORKDIR}/pe"
tar -C "${WORKDIR}/pe" -xzf "${WORKDIR}/pe.tar.gz" --strip-components 1

cat > /etc/yum.repos.d/pe.repo <<EOF
[pe]
name=Puppet, Inc. PE Packages \$releasever - \$basearch
baseurl=file://${WORKDIR}/pe/packages/${PLATFORM}-x86_64
enabled=True
gpgcheck=1
gpgkey=file://${WORKDIR}/pe/packages/GPG-KEY-puppet
        file://${WORKDIR}/pe/packages/GPG-KEY-puppet-2025-04-06
EOF

# Continue the process

yum install -y puppet-agent pe-puppet-enterprise-release pe-postgresql11-devel

git clone https://github.com/puppetlabs/puppet-data-service.git
pushd puppet-data-service
  make clean
  make rpm
  RPMFILE=$(ls *.rpm | head -1)
  mv "${RPMFILE}" "${WORKDIR}"
popd

echo "::set-output name=filename::${RPMFILE}"
