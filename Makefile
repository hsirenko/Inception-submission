NAME := inception

WP_VOLUME := /home/${USER}/data/wordpress
MARIADB_VOLUME := /home/${USER}/data/mariadb
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml

DOCKER_COMPOSE := docker compose -f $(DOCKER_COMPOSE_FILE)

all: $(NAME)

$(NAME): create-volumes
	$(DOCKER_COMPOSE) up --build

create-volumes:
	mkdir -p $(WP_VOLUME) $(MARIADB_VOLUME)

up: create-volumes
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

start:
	$(DOCKER_COMPOSE) start

restart: down up

s:
	$(DOCKER_COMPOSE) logs

ps:
	$(DOCKER_COMPOSE) ps

clean:
	$(DOCKER_COMPOSE) down
	@docker image prune -f
	@docker container prune -f
	@docker network prune -f
	@docker system prune -af

fclean: down
	@echo "Cleaning up..."
	@if [ -d "$(HOME)/data/wordpress" ]; then \
		echo "Fixing WordPress permissions..."; \
		sudo chown -R $(USER):$(USER) $(HOME)/data/wordpress; \
		rm -rf $(HOME)/data/wordpress/*; \
	fi
	@if [ -d "$(HOME)/data/mariadb" ]; then \
		echo "Fixing MariaDB permissions..."; \
		sudo chown -R $(USER):$(USER) $(HOME)/data/mariadb; \
		rm -rf $(HOME)/data/mariadb/*; \
	fi
	@echo "Removing containers and images..."
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	@docker system prune -af
	@echo "Cleanup complete!"

re: fclean $(NAME)

setup:
	@echo "Setting up directories..."
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p $(HOME)/data/mariadb
	@chmod 777 $(HOME)/data/wordpress
	@chmod 777 $(HOME)/data/mariadb
	@echo "Directories created and permissions set"

.PHONY: all up down stop start restart s ps clean fclean re setup
