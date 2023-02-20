include srcs/.env

docker_ps = $(shell docker ps -qa)
name = inception
all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

build:
	@printf "Building configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build
	@docker exec -it wordpress wp core install --url=$(DOMAIN_NAME) --title=$(WP_TITLE) --admin_user=$(WP_ADMIN) --admin_password=$(WP_ADMIN_PASSWORD) --admin_email=$(WP_ADMIN_EMAIL) --skip-email
	@docker exec -it wordpress wp user create $(WP_USER) $(WP_USER_EMAIL) --role=$(WP_USER_ROLE) --user_pass=$(WP_USER_PASSWORD)

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build
	@docker exec -it wordpress wp core is-installed
	@if [ "$$?" = 1 ]; then \
		docker exec -it wordpress wp core install --url=$(DOMAIN_NAME) --title=$(WP_TITLE) --admin_user=$(WP_ADMIN) --admin_password=$(WP_ADMIN_PASSWORD) --admin_email=$(WP_ADMIN_EMAIL) --skip-email ; \
		docker exec -it wordpress wp user create $(WP_USER) $(WP_USER_EMAIL) --role=$(WP_USER_ROLE) --user_pass=$(WP_USER_PASSWORD) ; \
	fi

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean:
	@printf "Total clean of all configurations docker\n"
ifneq ($(shell docker ps -q),)
	@docker stop $$(docker ps -qa)
endif
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*
ifneq ($(shell docker volume ls -q),)
	@docker volume rm $$(docker volume ls -q)
endif

.PHONY	: all build down re clean fclean
