#ARG PYTHON_VERSION=3.7.4-buster
ARG DEBIAN_VERSION=buster
FROM debian:${DEBIAN_VERSION}
ARG MAINTAINER="AGeekInside <marcwbrooks@gmail.com>"
LABEL MAINTAINER $(MAINTAINER)

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  apt-utils \
  build-essential \
  curl \
  git \
  nodejs \
  npm \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install bat
RUN wget --no-check-certificate https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb \
  && wget --no-check-certificate https://github.com/Peltoche/lsd/releases/download/0.16.0/lsd-musl_0.16.0_amd64.deb \
  && dpkg -i bat_0.11.0_amd64.deb \
  && dpkg -i lsd-musl_0.16.0_amd64.deb \
  && rm bat_0.11.0_amd64.deb lsd-musl_0.16.0_amd64.deb

# RUN curl -k https://sh.rustup.rs -sSf | bash -s -- -y
# RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

# Install Docker for docker in docker
VOLUME /var/lib/docker

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - 
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" \
  && apt-get update \
  && apt-get install -y docker-ce docker-ce-cli containerd.io \
  && rm -rf /var/lib/apt/lists/*

ENV COMPOSE_VERSION 1.24.1

RUN curl -ksSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Add user for dev work
ARG DEV_USER=ageekinside
ARG UID=1000
ARG GID=1000
RUN useradd --create-home --uid ${UID} --shell /bin/bash ${DEV_USER}
RUN adduser ${DEV_USER} sudo
RUN usermod -aG docker ${DEV_USER}
RUN usermod -aG root ${DEV_USER}

# Install neovim
RUN apt-get update \
  && apt-get install -y \
    neovim \
    python3-neovim \
  && rm -rf /var/lib/apt/lists/*

# Install git town
ENV GIT_TOWN_VERSION 7.2.1
RUN curl -ksSL "https://github.com/Originate/git-town/releases/download/v${GIT_TOWN_VERSION}/git-town-amd64.deb" -o /tmp/git-town-amd64.deb \
  && dpkg -i /tmp/git-town-amd64.deb

# Install libraries required for compiling Python 

RUN apt-get update \
  && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
  && rm -rf /var/lib/apt/lists/*
USER ${DEV_USER}
ENV HOME /home/${DEV_USER}
#RUN mkdir -p $HOME/.venv
#ENV VIRTUAL_ENV=$HOME/.venv
#RUN python3 -m venv $VIRTUAL_ENV
#ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN mkdir /home/${DEV_USER}/scripts
ADD resources/two_line_prompt.sh /home/${DEV_USER}/scripts/two_line_prompt.sh

RUN echo "source /home/${DEV_USER}/scripts/two_line_prompt.sh" >> /home/${DEV_USER}/.bashrc
WORKDIR /home/${DEV_USER}

# TODO add in fixuid code

https://github.com/boxboat/fixuid

# RUN mkdir tools
# RUN git clone https://github.com/ryanoasis/nerd-fonts.git tools/nerd-fonts

CMD ["/bin/bash"]
