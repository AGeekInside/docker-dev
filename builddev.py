#!/usr/bin python
"""Utility to build out a python dev environment."""

import click
import os

from shutil import copyfile

from cookiecutter.main import cookiecutter


DEFAULT_DIR = "./workspaces"
PYTHON_RECIPE = "./cookie-cutter/python-dev/"


def populate_recipe(recipe_root):
    """Populates the recipe area."""

    files_to_copy = [
        "resources/start_devshell.sh",
        "resources/start-dev-env.sh",
        "resources/print_make_help.py",
    ]

    for file_to_copy in files_to_copy:
        copyfile(file_to_copy, recipe_root + f"/{file_to_copy}")


def run_cookiecutter(name, username, recipe):
    """Runs cookiecutter with the specified recipe."""

    curr_dir = os.getcwd() + "/"
    os.chdir(DEFAULT_DIR)
    cookiecutter(
        curr_dir + recipe,
        no_input=True,
        extra_context={"directory_name": name, "username": username, "name": name},
    )


@click.command()
@click.option(
    "-n",
    "--name",
    prompt="Name of the project",
    help="Name of the project to build env for.",
)
@click.option(
    "-d",
    "--directory",
    default=DEFAULT_DIR,
    show_default=DEFAULT_DIR,
    help="Directory that contains development environments.",
)
@click.option(
    "--username",
    prompt=True,
    default=lambda: os.environ.get("USER", ""),
    show_default="current user",
    help="Username to use in the docker development environment.",
)
@click.option(
    "-r", "--repo", help="Repo to clone for development environment.", default=None
)
def build_dev_env(name, directory, username, repo):
    """Builds a dev env/directory with the needed files to build a docker dev env."""

    print(f"Preparing development environment for {name} in {directory}.")

    recipe_root = PYTHON_RECIPE + "/{{cookiecutter.directory_name}}"

    populate_recipe(recipe_root)

    run_cookiecutter(name, username, recipe=PYTHON_RECIPE)

    dev_env_dir = directory + f"/{name}"

    if repo:
        clone_repo(dev_env_dir)


if __name__ == "__main__":
    build_dev_env()
