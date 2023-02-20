FROM alpine:3.16

RUN	apk update && apk upgrade && apk add --no-cache nginx

COPY	./requirements/nginx/conf/* /etc/nginx/http.d/
COPY	./requirements/nginx/tools/* /etc/nginx/ssl/

EXPOSE	443

CMD	[ "nginx", "-g", "daemon off;"]
