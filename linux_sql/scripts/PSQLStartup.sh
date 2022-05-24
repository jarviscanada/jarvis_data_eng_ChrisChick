#!/bin/bash

#get latest postgres
docker pull postgres

#Create new volume
docker volume create pgdata

#set password as 'postgres'
export PGPASSWORD='password'

#create container using psql image with name=jrvs-psql
docker run --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine

#start container
docker container start jrvs-psql

#Install psql CLI client
sudo yum install -y postgresql
