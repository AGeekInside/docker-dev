FROM ageekinside/base

# install pyenv

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
RUN echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bash_profile
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:$PATH"
ENV HOME  /home/ageekinside
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN mkdir ~/workspace
WORKDIR ~/workspace

RUN pyenv install 3.7.4 
#RUN pyenv install 3.8-dev 
#RUN pyenv install 3.9-dev 
#RUN pyenv install 3.6.9
RUN pyenv global 3.7.4 
RUN pyenv rehash

RUN python3 -m pip install --user pipx
RUN python3 -m pipx ensurepath

RUN pipx install nox
RUN pipx install poetry

RUN poetry completions bash > /etc/bash_completion.d/poetry.bash-completion

CMD ["/bin/bash"]
