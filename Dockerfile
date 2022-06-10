FROM alpine:latest as build
MAINTAINER Deepak Panwar <erdipak.panwar@gmail.com>
ARG HELM_LATEST_VERSION=v3.8.2
WORKDIR /
RUN apk add --update --no-cache ca-certificates git curl tar gzip unzip python3 py3-pip

# Installing Helm3
RUN curl -LO "https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz"
RUN tar -xzvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
# RUN mv linux-amd64/helm /usr/local/bin/helm
# RUN rm -f helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz

# Installing kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl
#RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Installing KOps
RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
RUN chmod +x kops
#RUN mv kops /usr/local/bin/kops

# Installing AWS CLI V2
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# RUN unzip awscliv2.zip
# RUN ./aws/install
# RUN rm -f awscliv2.zip

# Installing Azure CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

FROM alpine:latest
COPY cluster-create.py .
RUN apk add --update --no-cache ca-certificates python3 py3-pip
COPY --from=build /linux-amd64/helm /usr/local/bin/helm
COPY --from=build /kubectl /usr/local/bin/kubectl
COPY --from=build /kops /usr/local/bin/kops
RUN pip3 install awscli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash






