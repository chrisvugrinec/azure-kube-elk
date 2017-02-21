FROM ubuntu
MAINTAINER chvugrin@microsoft.com
COPY x.tar /opt
RUN apt-get update && \
  apt-get install -y git && \
  apt-get install -y jq && \
  apt-get install -y uuid && \
  apt-get install -y wget && \
  apt-get install -y curl && \
  apt-get install -y nodejs && \
  apt-get install -y npm && \
  apt-get install -y vim && \
  npm -g install azure-cli && \
  mkdir ~/.kube && \
  ln -s /usr/bin/nodejs /usr/bin/node && \
  cd $HOME && \
  git clone https://github.com/cvugrinec/microsoft.git && \
  git clone https://github.com/Azure/acs-engine.git && \
  cd /opt && \
  tar -xvf x.tar && \
  wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz && \
  cd /usr/local && \
  tar -zxvf /opt/go1.7.3.linux-amd64.tar.gz && \
  cd /usr/local/bin && \
  curl -O https://storage.googleapis.com/kubernetes-release/release/v1.4.3/bin/linux/amd64/kubectl && \
  chmod 750 kubectl && \
  rm -f /opt/go1.7.3.linux-amd64.tar.gz && \
  mkdir ~/.ssh && \
  mkdir $HOME/gopath && \
  ssh-keygen -t rsa -f  ~/.ssh/id_rsa -P ""
ENV PATH="/usr/local/go/bin:${PATH}"
