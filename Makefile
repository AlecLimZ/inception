include srcs/.env

name = inception
all:
	@printf "Launch docker-compose up without build for ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

build:
	@printf "Building custom images for ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build
	@docker exec -it wordpress wp core install --url=$(DOMAIN_NAME) --title=$(WP_TITLE) --admin_user=$(WP_ADMIN) --admin_password=$(WP_ADMIN_PASSWORD) --admin_email=$(WP_ADMIN_EMAIL) --skip-email
	@docker exec -it wordpress wp user create $(WP_USER) $(WP_USER_EMAIL) --role=$(WP_USER_ROLE) --user_pass=$(WP_USER_PASSWORD)

stop:
	@printf "Stopping ${name} containers...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

restart:
	@printf "Restart ${name} containers...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down
	@sleep 3
	@printf "it is starting up..\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

re:
	@printf "Rebuild ${name} containers...\n"
	@docker rm -f $$(docker ps -qa)
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: stop
	@printf "Cleaning ${name} containers...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean:
	@printf "Erase ${name} completely!!\n"
ifneq ($(shell docker ps -q),)
	@docker stop $$(docker ps -qa)
endif
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data
ifneq ($(shell docker volume ls -q),)
	@docker volume rm $$(docker volume ls -q)
endif

.PHONY	: all build down re clean fclean
