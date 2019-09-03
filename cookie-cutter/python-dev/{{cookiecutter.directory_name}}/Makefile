.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help
define BROWSER_PYSCRIPT
import os, webbrowser, sys
try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

PYDEV_PROJECT={{cookiecutter.name}}

help:
	@python resources/print_make_help.py Makefile

build-dev : ## Builds the {{cookiecutter.name}} dev image
	docker build -t ageekinside/dev/${PYDEV_PROJECT} -f docker/dev-${PYDEV_PROJECT}.Dockerfile .

dev-up: ## Stands up a Python dev env.
	resources/start-pydev-project.sh ${PYDEV_PROJECT}

dev-attach : ## Attachs to the python development container.
	docker exec -it \
		${PYDEV_PROJECT}_workspace_1 /bin/bash 
