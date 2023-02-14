all:
	@echo "hello!"

down:
	docker compose down --remove-orphans

clean:
	docker rm -f $(docker ps -qa)

fclean:	clean
	docker image rm -f $(docker image ls -qa)

re:	fclean all

.PHONY:	all down clean fclean re
