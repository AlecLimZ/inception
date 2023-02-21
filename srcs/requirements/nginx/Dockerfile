FROM alpine:3.16

RUN	apk update && apk upgrade && apk add --no-cache nginx

COPY	./requirements/nginx/conf/* /etc/nginx/http.d/
COPY	./requirements/nginx/tools/* /etc/nginx/ssl/

# copy ssl certificate/key to nginx container's directory

EXPOSE	443

CMD	[ "nginx", "-g", "daemon off;"]

# -g means set a parameter as a global command to apply on the entire Nginx process

# daemon off allows nginx to run in foreground instead of the background of the standard output after launch nginx. Some articles on internet said useful for debugging. 
