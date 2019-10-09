ARG BASE_REPO=ageekinside
FROM ${BASE_REPO}/base

USER root
RUN wget -O /usr/local/share/ca-certificates/MITRE-BA-Root.crt http://pki.mitre.org/MITRE%20BA%20Root.crt
RUN wget -O /usr/local/share/ca-certificates/MITRE-BA-NPE-CA-3.crt "http://pki.mitre.org/MITRE%20BA%20NPE%20CA-3(1).crt"
RUN update-ca-certificates

ENV DEBIAN_FRONTEND=noninteractive

ARG DEV_USER=ageekinside