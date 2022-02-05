#!/bin/bash
set -e

# Inputs

PE_VERSION=${1:-2021.4.0}
PLATFORM=${PLATFORM:-el-7}
GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-/workspace}
SCRATCHDIR=${SCRATCHDIR:-/scratch}

# Download PE and install required dependent packages

mkdir -p "${SCRATCHDIR}/pe"
curl -o "${SCRATCHDIR}/pe.tar.gz" "https://s3.amazonaws.com/pe-builds/released/${PE_VERSION}/puppet-enterprise-${PE_VERSION}-${PLATFORM}-x86_64.tar.gz"
tar -C "${SCRATCHDIR}/pe" -xzf "${SCRATCHDIR}/pe.tar.gz" --strip-components 1

cat > /etc/yum.repos.d/pe.repo <<EOF
[pe]
name=Puppet, Inc. PE Packages \$releasever - \$basearch
baseurl=file://${SCRATCHDIR}/pe/packages/${PLATFORM}-x86_64
enabled=True
gpgcheck=1
gpgkey=file://${SCRATCHDIR}/pe/packages/GPG-KEY-puppet
        file://${SCRATCHDIR}/pe/packages/GPG-KEY-puppet-2025-04-06
EOF

yum install -y puppet-agent pe-puppet-enterprise-release pe-postgresql11-devel

# Create the RPM

# It is assumed/required that the puppet-data-service project is already
# checked out in the GITHUB_WORKSPACE.
mkdir -p "${GITHUB_WORKSPACE}"
pushd "${GITHUB_WORKSPACE}"
  make clean
  make rpm
  RPMFILE=$(ls -t *.rpm | head -1)
popd

echo "::set-output name=filename::${RPMFILE}"
