FROM nginx:alpine

WORKDIR /var/share/nginx/html

COPY ./app .

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]


