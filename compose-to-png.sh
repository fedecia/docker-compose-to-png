#!/bin/bash
if [ -z $1 ]; then
  echo Usage: ./compose-to-png.sh path-to-docker-compose.yml [output-png-file]
  exit 1
fi
path=$1
directory=$(dirname $path)
output=${2:-/tmp/docker_dependencies.png}
source $directory/.env
export $(cut -d= -f1 $directory/.env)
export LOCAL_USER_ID=0
envsubst < $path
envsubst < $path | docker run -i funkwerk/compose_plantuml --port_boundaries --link-graph | docker run -i think/plantuml -tpng > $output
echo File created at $output