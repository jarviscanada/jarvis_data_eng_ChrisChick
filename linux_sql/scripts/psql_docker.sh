#! /bin/sh

#input arguments
cmd=$1
db_username=$2
db_password=$3

#Start docker
sudo systemctl status docker || systemctl start docker

#check container status
docker container inspect jrvs-psql
container_status=$?

#switch case for create|stop|start options
case $cmd in
  create)

  # Check if the container is created
  if [ $container_status -eq 0 ]; then
		echo 'Container already exists'
		exit 1
	fi

  #check # of arguments
  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi

  #Create container
	docker volume create $db_username
	docker run $db_username./scripts/psql_docker.sh create db_username db_password
	exit $?
	;;

  start|stop)
  #check instance status; exit 1 if container has not been created
  if [ $container_status -ne 0 ]; then
    echo 'Container does not exist'
    exit 1
  fi

  #Start or stop the container
	docker container $cmd jrvs-psql
	exit $?
	;;

  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;
esac
exit 0