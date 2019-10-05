ARG BASE_REPO=ageekinside
FROM ${BASE_REPO}/base

ARG GO_VERSION=1.13
ARG OS=linux
ARG ARCH=amd64
ARG DEV_USER=ageekinside
# Download and install go

USER root
RUN wget --no-check-certificate \
    https://dl.google.com/go/go${GO_VERSION}.${OS}-${ARCH}.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.${OS}-${ARCH}.tar.gz \
    && echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

USER ${DEV_USER}

RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /home/${DEV_USER}/.bash_profile
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> /home/${DEV_USER}/.bashrc