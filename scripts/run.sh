#!/usr/bin/env bash

# Stop and remove existing container
docker stop poems &> /dev/null
docker rm poems &> /dev/null

# Start container
docker run -d --name poems --rm -p 8000:8000 poems
