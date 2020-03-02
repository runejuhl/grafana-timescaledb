.PHONY: up-default up-tsrelay up down clean logs psql start
up:
	docker-compose up -d -V --build --force-recreate grafana timescaledb netdata

#todo add wait-for-it.sh to tsrelay container
up-tsrelay:
	sleep 10 && docker-compose up -d -V --build --force-recreate tsrelay

down:
	docker-compose down -v

clean:
	docker-compose rm -f

logs:
	docker-compose logs -f

psql:
	docker exec -ti --user user1 grafana-timescaledb_timescaledb_1 psql metrics

start: down up up-tsrelay
	docker-compose logs -f