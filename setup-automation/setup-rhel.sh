!#/bin/bash

# Pull the UBI image to avoid during lab time
podman pull registry.access.redhat.com/ubi10/ubi

# Create the example containerfile
mkdir -p ~/my-container/
cat << EOF >> ~/my-container/Containerfile
FROM registry.access.redhat.com/ubi10/ubi
RUN dnf -y install httpd
EXPOSE 80
CMD ["/usr/sbin/httpd","-DFOREGROUND"]
EOF

# Create the index.html
# moved from step 2 setup script

mkdir -p ~/my-container/app
cat << EOF >> ~/my-container/app/index.html
<HTML>
<HEAD>
<TITLE>My Web App</TITLE>
</HEAD>
This is my web app
</HTML>
EOF
