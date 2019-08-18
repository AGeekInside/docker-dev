FROM ageekinside/base

ADD base_packages.txt $HOME

RUN pip install -r base_packages.txt \
    && rm base_packages.txt

