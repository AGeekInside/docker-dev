.phony: help

help:
	@echo "in help"

build-base : ## Builds the base dev image
	docker build -t ageekinside/base -f images/base.Dockerfile .

build-pydev : build-base ## Builds the python dev image
	docker build -t ageekinside/pydev -f images/pydev.Dockerfile .
