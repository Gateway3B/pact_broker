#!/bin/sh

rake build
docker stop pactbroker
docker rm pactbroker
docker stop postgres
docker rm postgres
docker run --name postgres -e POSTGRES_PASSWORD=postgrespassword -d postgres

docker pull pactfoundation/pact-broker:latest
docker run --name=pactbroker -d -p 80:9292 -e PACT_BROKER_LOG_LEVEL=DEBUG -e PACT_BROKER_DATABASE_USERNAME=postgres -e PACT_BROKER_DATABASE_PASSWORD=postgrespassword -e PACT_BROKER_DATABASE_HOST=172.17.0.2 -e PACT_BROKER_DATABASE_NAME=postgres -e PACT_BROKER_DATABASE_PORT=5432 pactfoundation/pact-broker:latest
docker exec --user root pactbroker mkdir repo
docker exec --user root pactbroker mkdir repo/gems
docker cp pkg/pact_broker-2.58.1.gem pactbroker:pact_broker/repo/gems/pact_broker-2.58.1.gem
docker exec --user root pactbroker gem install builder
docker exec --user root -w /pact_broker/repo pactbroker gem generate_index
docker exec --user root pactbroker apk add build-base
docker exec --user root pactbroker sed -i '3s@.*@gem \"pact_broker\", \"~>2.58.1\" ,source: \"file:////pact_broker/repo\"@' Gemfile
docker exec --user root pactbroker bundle config --delete frozen
docker exec --user root pactbroker bundle install
docker commit pactbroker modified_pact-broker
docker stop pactbroker
docker rm pactbroker
docker stop postgres
docker rm postgres
docker run --name postgres -e POSTGRES_PASSWORD=postgrespassword -d postgres
docker run --name=pactbroker -d -p 80:9292 -e PACT_BROKER_LOG_LEVEL=DEBUG -e PACT_BROKER_DATABASE_USERNAME=postgres -e PACT_BROKER_DATABASE_PASSWORD=postgrespassword -e PACT_BROKER_DATABASE_HOST=172.17.0.2 -e PACT_BROKER_DATABASE_NAME=postgres -e PACT_BROKER_DATABASE_PORT=5432 modified_pact-broker
# docker exec -it --user root pactbroker sh
# /pact_broker/vendor/bundle/ruby/2.6.0/gems