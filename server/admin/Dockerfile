FROM nginx

RUN rm /etc/nginx/conf.d/default.conf

COPY conf /etc/nginx

COPY dist /var/www/dist

CMD service nginx start
