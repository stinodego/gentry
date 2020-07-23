#!/usr/bin/env -S bash -x -e

autoflake --recursive --remove-all-unused-imports --remove-unused-variables --in-place src tests
black src tests
isort src tests
