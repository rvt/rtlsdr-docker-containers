#sudo timedatectl set-timezone UTC
docker-compose stop
#exit
docker-compose pull
docker-compose up --force-recreate --build
