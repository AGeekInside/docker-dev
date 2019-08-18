ARG PYTHON_VERSION=3.7.4-buster

FROM python:${PYTHON_VERSION}

LABEL MAINTAINER AGeekInside <marcwbrooks@gmail.com>

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

RUN curl -ksSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Add user for dev work
RUN useradd --create-home --shell /bin/bash ageekinside
RUN adduser ageekinside sudo

USER ageekinside
ENV HOME /home/ageekinside
RUN mkdir -p $HOME/.venv
ENV VIRTUAL_ENV=$HOME/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN mkdir /home/ageekinside/scripts
ADD two_line_prompt.sh /home/ageekinside/scripts/two_line_prompt.sh

RUN echo "source /home/ageekinside/scripts/two_line_prompt.sh" >> /home/ageekinside/.bashrc
RUN echo "source /home/ageekinside/scripts/two_line_prompt.sh" >> /home/ageekinside/.bash_profile
WORKDIR /home/ageekinside

# update pip
RUN pip install --upgrade pip

# RUN mkdir tools
# RUN git clone https://github.com/ryanoasis/nerd-fonts.git tools/nerd-fonts

CMD ["/bin/bash"]
