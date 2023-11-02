# Use an appropriate base image
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /

# Install install Node.js
RUN set -uex; \
    apt-get update; \
    apt-get install -y ca-certificates curl gnupg; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
     | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    NODE_MAJOR=18; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" \
     > /etc/apt/sources.list.d/nodesource.list; \
    apt-get -qy update; \
    apt-get -qy install nodejs;

# Copy your project files
COPY . .
WORKDIR /usercode
COPY . .


# Set up the client environment and install client dependencies
WORKDIR /musicshare/client
RUN npm install

# Set up the server environment and install server dependencies
WORKDIR /musicshare/server
RUN npm install 

# create node modules symlink for the server dir
RUN ln -s /musicshare/server/node_modules /usercode/musicshare/server/node_modules

# create node modules symlink for the client dir
RUN ln -s /musicshare/client/node_modules /usercode/musicshare/client/node_modules

# ## Fixing etc/hosts
# RUN echo "127.0.0.1       localhost" >> /etc/hosts && \
#     echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts  && \
#     echo "fe00::0 ip6-localnet" >> /etc/hosts && \
#     echo "ff00::0 ip6-mcastprefix" >> /etc/hosts && \
#     echo "ff02::1 ip6-allnodes" >> /etc/hosts && \
#     echo "ff02::2 ip6-allrouters" >> /etc/hosts && \
#     echo "172.17.0.3      e2d7ddabb2c5" >> /etc/hosts