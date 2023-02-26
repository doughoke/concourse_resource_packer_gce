FROM google/cloud-sdk:419.0.0-alpine

RUN apk --no-cache add jq ca-certificates openssh-client sed

ARG PACKER_VER=1.8.6

RUN wget -O /tmp/packer.zip \
    "https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip" \
  && unzip -o /tmp/packer.zip -d /usr/local/bin \
  && rm -f /tmp/packer.zip

ADD bin /opt/resource
