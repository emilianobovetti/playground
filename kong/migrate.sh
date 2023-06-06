docker compose --profile db run --rm kong-gateway kong migrations bootstrap
docker compose down --remove-orphans
