OTRS Community Edition - v6.0.37
Mantainer: Rafael Ferraz de Queiroz - https://github.com/rafael-ferraz

This image create a multi-container OTRS 6 Comunnity Edition over the port 8081.

PREREQUISITES:

- Docker Compose

BUILD INSTRUCTIONS:

1 - Clone repository: git clone https://github.com/rafael-ferraz/otrs6.git
2 - Run image: docker-compose up -d
3 - Access Container: docker exec -it <container id> bash
4 - URL: http://localhost:8081/otrs/index.pl

To start OTRS Daemon, execute the command over APP container: su otrs -c "/opt/otrs/bin/otrs.Daemon.pl start"

Default OTRS Credentials:

- Login: root@localhost
- Password: root

MySQL root password:

- Login: root
- Password: pass@123

Some docker commands:

- List container(s): docker ps -a
- List image(s): docker images
- Start/Stop container: docker <stop/start> <container id>
- Remove stopped container: docker rm <container id>
- Remove image: docker rmi <image id>
- Remove containers and images from stopped images: docker system prune -a