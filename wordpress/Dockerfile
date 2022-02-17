FROM wordpress:latest

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
