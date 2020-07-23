# POEMS

This is a simple application that pulls up a random poem.

In later iterations, the app will generate poems automatically.

## Setup

This project uses [poetry](https://python-poetry.org/) for dependency management. Install this first, using:

`curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python`

Clone the repository:

`git clone https://gitlab.com/stinodego/poems.git`

After cloning the repository, run the following command from the project base directory:

`poetry install`

This project defines pre-commit hooks. To use these, install the hooks:

`poetry run pre-commit install`
