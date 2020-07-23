#!/usr/bin/env bash

set -xe

pytest --cov=src --cov-report=term-missing:skip-covered -W ignore::DeprecationWarning "${@}"
