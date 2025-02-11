```sh
# start haproxy and echo servers
docker compose up --watch

# inspect `table_name` state
docker compose exec haproxy sh -c 'echo "show table table_name" | socat stdio UNIX-CONNECT:/var/lib/haproxy/stats'

# send fake requests
while true; do curl --silent --output /dev/null --data '{}' localhost:8080/graphql; sleep 0.5; done
```
