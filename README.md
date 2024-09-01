# booking-system-deploy

This project uses Docker Compose and Traefik to run a multi-container application.

## Requirements

- Docker
- Docker Compose

acme.json needs chmod 600 and the file created beforehand, please also check new bind type in volumes for traefik

## Running the app

- sudo docker-compose --env-file .env up -d

## Configuration

All of the configuration for the application is stored in the `docker-compose.yaml` file and the `traefik/traefik.yaml` file. You can customize these files to suit your needs.

