import click

from environs import Env


def read_env():
    """Reads various configuration options from the environment."""

    env = Env()
    
    dev_user = env("USER")

    env_dict = {
        "dev_user": dev_user,
    }

    return env_dict


@click.command()
@click.argument("src_dir")
def spin_dev_container(src_dir : str):
    """Starts a docker container with the directory mounted as workspace."""

    env_dict = read_env()


if __name__ == "__main__":
    spin_dev_container()
