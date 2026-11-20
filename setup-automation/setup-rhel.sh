#!/bin/bash
set -x
trap 'echo "FATAL: setup failed at line ${LINENO}" >> /tmp/progress.log; exit 1' ERR

echo "Setup zt-podman-containerfile" > /tmp/progress.log
chmod 666 /tmp/progress.log

# Registration and the git install stay inline and ahead of the library clone:
# the EUS base image ships without git, and the library is sourced via git clone.
# These can move behind the library once git is part of the image build.
dnf -y remove katello-ca-consumer-* 2>/dev/null || true
subscription-manager clean
subscription-manager register --activationkey="${ACTIVATION_KEY}" --org="${ORG_ID}" --force
dnf install -y git podman

LIBDIR=/tmp/lab-lib-$$
git clone --depth=1 https://github.com/rhel-labs/lab-setup "${LIBDIR}"
. "${LIBDIR}/common.sh"
echo "Packages installed" >> /tmp/progress.log

# Pre-pull the lab images into the rhel user's storage (the lab session runs as rhel)
pull_public_images rhel \
    registry.access.redhat.com/ubi10/ubi \
    registry.access.redhat.com/ubi10/ubi-init \
    registry.access.redhat.com/hi/httpd
echo "Images staged in rhel user storage" >> /tmp/progress.log

# Fetch setup files from the lab git repository
fetch_setup_files content/modules/ROOT/examples/app
echo "Setup files staged" >> /tmp/progress.log

# Stage the working directory for the lab user.
# The Containerfile itself is authored by the learner in module-01.
mkdir -p /home/rhel/my-container/app
cp "${SETUP_FILES}"/* /home/rhel/my-container/app/
chown -R rhel:rhel /home/rhel/my-container
echo "Working directory staged" >> /tmp/progress.log

cleanup_subscription
cleanup_tmpfiles
echo "Setup complete" >> /tmp/progress.log
