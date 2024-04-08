#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P)"
cd "$SCRIPTPATH"

if [ "$(uname -m)" = "arm64" ]
then
  cp ../builds/arch_build ../Dockerfile
else
  cp ../builds/x86_64_build ../Dockerfile
fi

cd ../tests

docker-compose build --no-cache
docker-compose up -d

sleep 5

newman run todo.postman_collection.json

docker-compose down
docker image rm test_server
docker image rm init_test_db
docker image rm test_postgres
rm ../Dockerfile
