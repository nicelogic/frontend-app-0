
FROM nginx
# WORKDIR /usr/share/nginx/html
COPY ./app/build/web/ /usr/share/nginx/html
COPY ./docker/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

