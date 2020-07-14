# Stop and remove existing container
docker stop poems &> /dev/null
docker rm poems &> /dev/null

# Start container
docker run -d --name poems --rm -P poems
