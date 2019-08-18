FROM ageekinside/base

RUN mkdir ${HOME}/workspace
WORKDIR ${HOME}/workspace

# Section to install baseline packages used for development

RUN python3 -m pip install --upgrade pip

ADD base-packages.txt ${HOME}/workspace

RUN python3 -m pip install -r base-packages.txt \
    && rm base-packages.txt

CMD ["/bin/bash"]
