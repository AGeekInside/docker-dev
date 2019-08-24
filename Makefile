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

PYDEV_PROJECT=pydev

help:
	@python resources/print_make_help.py Makefile

build-base : ## Builds the base dev image
	docker build -t ageekinside/base -f dockerfiles/base.Dockerfile .

build-pydev : build-base ## Builds the python dev image
	docker build -t ageekinside/pydev -f dockerfiles/pydev.Dockerfile .

pydev-up: ## Stands up a Pythond dev env.
	resources/start-pydev-project.sh ${PYDEV_PROJECT}
	#docker-compose \
		#--project-name ${PYDEV_PROJECT} \
		#--file dockerfiles/pydev.docker-compose.yml \
		#up --detach

pydev-attach : ## Attachs to the python development container.
	docker exec -it \
		${PYDEV_PROJECT}_workspace_1 /bin/bash 
