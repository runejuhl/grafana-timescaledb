BOOTSTRAP_SQL ?= ./init-db.sql
PG_RESTORE = pg_restore --create --if-exists --clean $(DB_DUMP)
DC_PROMETHEUS_CONFIG = docker-compose.yml
DC_ALERTA_CONFIG = docker-compose.alerta.yml

DC_ALERTA = docker-compose -f $(DC_ALERTA_CONFIG) -f $(DC_PROMETHEUS_CONFIG)

export COMPOSE_PROJECT_NAME=grafana-timescaledb

.PHONY: docker
docker: Dockerfile.netdata-tsrelay
	docker build -f Dockerfile.netdata-tsrelay -t runejuhl/netdata-tsrelay:$(shell date +%s) . # -t runejuhl/netdata-tsrelay:latest

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
	docker-compose logs -f --tail=5

.PHONY: psql
psql:
	docker exec -ti --user postgres grafana-timescaledb_timescaledb_1 psql metrics

.PHONY: bootstrap
bootstrap: $(BOOTSTRAP_SQL)
	docker exec -i --user postgres grafana-timescaledb_timescaledb_1 psql postgres < $(BOOTSTRAP_SQL)

.PHONY: alerta/up
alerta/up:
	$(DC_ALERTA) up -d

.PHONY: alerta/logs
alerta/logs:
	$(DC_ALERTA) logs -f --tail=5
