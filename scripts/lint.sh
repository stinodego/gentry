#!/usr/bin/env bash

set -x

mypy src
black --check src tests
isort --check src tests
flake8 src tests
