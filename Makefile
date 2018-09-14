BOOTSTRAP_SQL ?= ./init-db.sql
PG_RESTORE = pg_restore --create --if-exists --clean $(DB_DUMP)

.PHONY: docker
docker: Dockerfile.netdata-tsrelay
	docker build -f Dockerfile.netdata-tsrelay -t runejuhl/netdata-tsrelay:latest -t runejuhl/netdata-tsrelay:$(shell date +%s) .

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose kill

.PHONY: clean
clean:
	docker-compose rm -f

.PHONY: logs
logs:
	docker-compose logs -f

.PHONY: psql
psql:
	docker exec -ti --user postgres grafanatimescaledb_timescaledb_1 psql metrics

.PHONY: bootstrap
bootstrap: $(BOOTSTRAP_SQL)
	docker exec -i --user postgres grafanatimescaledb_timescaledb_1 psql postgres < $(BOOTSTRAP_SQL)
