ARG CENTOS_VERSION=7.6.1810

FROM centos:${CENTOS_VERSION}

LABEL MAINTAINER AGeekInside <marcwbrooks@gmail.com>

RUN yum update -y 

RUN yum install -y \
    gcc make \
    zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
    openssl-devel xz xz-devel libffi-devel findutils tree \
    && yum clean all

RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install  git2u-all

# Add user for dev work
RUN useradd --create-home --shell /bin/bash ageekinside
RUN usermod -aG wheel ageekinside

USER ageekinside

CMD ["/bin/bash"]
