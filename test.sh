#!/usr/bin/env bash
docker network create conjur_external || echo "Network already exists"
docker-compose -f docker-compose.yml up
