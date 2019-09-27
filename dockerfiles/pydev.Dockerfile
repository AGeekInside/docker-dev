ARG BASE_REPO=ageekinside
FROM ${BASE_REPO}/base

# install pyenv
ARG DEV_USER=ageekinside
USER ${DEV_USER}

# REMOVE THIS, UNLESS YOU KNOW WHAT YOU ARE DOING
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
#RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
#RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
#RUN echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:${HOME}/.local/bin:$PATH"
ENV HOME /home/${DEV_USER}
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ARG PYTHON_VERSION=3.7.4
RUN pyenv install ${PYTHON_VERSION}
#RUN pyenv install 3.8-dev 
#RUN pyenv install 3.9-dev 
#RUN pyenv install 3.6.9
RUN pyenv global ${PYTHON_VERSION}
RUN pyenv rehash

RUN mkdir ${HOME}/workspace
WORKDIR ${HOME}/workspace

# Section to install baseline packages used for development

ADD resources/base-packages.txt ${HOME}/workspace

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r base-packages.txt

# Add startup scripts
RUN mkdir ${HOME}/env-setup
ADD resources/*dev-env.sh ${HOME}/env-setup/
USER root
RUN chmod +x ${HOME}/env-setup/*

USER ${DEV_USER}

CMD ["/bin/bash"]
