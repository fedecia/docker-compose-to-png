#!/bin/bash
# Generates a diagram of the docker compose service dependencies (depends-on) and their exposed ports
# Requires docker.
# Takes two params: path-to-docker-compose-file and optional [output-png-file]
if [ -z $1 ]; then
  echo Usage: ./compose-to-png.sh path-to-docker-compose.yml [output-png-file]
  exit 1
fi
path=$1
directory=$(dirname $path)
output=${2:-/tmp/docker_dependencies.png}
# Export all environment variables from .env file
source $directory/.env
export $(cut -d= -f1 $directory/.env)
# Replace all the environment variables in the docker-compose file
envsubst < $path | \ 
  docker run -i funkwerk/compose_plantuml --port_boundaries --link-graph | \
  docker run -i think/plantuml -tpng > $output
echo File created at $output
