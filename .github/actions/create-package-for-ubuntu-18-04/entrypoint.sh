#!/bin/bash
set -e

# Inputs

PE_VERSION=${1}
PLATFORM=${PLATFORM:-ubuntu-18.04}
RELEASE=${RELESE:-Bionic}
GITHUB_WORKSPACE=${GITHUB_WORKSPACE:-/workspace}
SCRATCHDIR=${SCRATCHDIR:-/scratch}

if [ -z "${PE_VERSION}" ]; then
  echo "ERROR: Did not recieve a valid PE version argument ($1)"
  exit 1
fi

# Download PE and install required dependent packages

mkdir -p "${SCRATCHDIR}/pe"
curl -o "${SCRATCHDIR}/pe.tar.gz" "https://s3.amazonaws.com/pe-builds/released/${PE_VERSION}/puppet-enterprise-${PE_VERSION}-${PLATFORM}-amd64.tar.gz"
tar -C "${SCRATCHDIR}/pe" -xzf "${SCRATCHDIR}/pe.tar.gz" --strip-components 1

wget https://apt.puppet.com/puppet7-release-${RELEASE}.deb
dpkg -i puppet7-release-${RELEASE}.deb
apt update
apt install -y puppet-agent pe-puppet-enterprise-release pe-postgresql11-devel

# Create the DEB

# It is assumed/required that the puppet-data-service project is already
# checked out in the GITHUB_WORKSPACE.
mkdir -p "${GITHUB_WORKSPACE}"
pushd "${GITHUB_WORKSPACE}"
  make clean
  make deb
  DEBFILE=$(find . -name '*.deb' -printf "%f\n" | head -1)
popd

echo "::set-output name=filename::${DEBFILE}"
