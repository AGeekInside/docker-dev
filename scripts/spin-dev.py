import os
import sys

import click
import docker

from environs import Env


@click.command()
@click.argument("src_dir")
@click.option("-r", "--repo", default="ageekinside")
def spin_dev_container(src_dir: str, repo: str):
    """Starts a docker container with the directory mounted as workspace."""

    if not os.path.isdir(src_dir):
        print(f"{src_dir} is a not a directory")
        sys.exit()

    abs_path_src = os.path.abspath(src_dir)

    image_name = f"{repo}/pydev"
    volume_target = f"/home/{repo}/workspace"

    client = docker.from_env()

    container_name = f"{os.path.basename(abs_path_src)}_dev"
    volume_dict = {abs_path_src: {"bind": volume_target}}

    print(
        f"Preparing to spin up container:\n"
        f"Image: {image_name}\n"
        f"Host dir: {abs_path_src}\n"
        f"Container name: {container_name}\n"
        f"Container workspace: {volume_target}\n"
    )
    client.containers.run(
        image_name, name=container_name, volumes=volume_dict, detach=True
    )


if __name__ == "__main__":
    spin_dev_container()
