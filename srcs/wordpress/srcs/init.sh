#!/bin/sh

# install wordpress
if [ ! "$(ls -A /var/www/wordpress)" ]; then
	tar -xvzf /tmp/wordpress.tar.gz -C /var/www/wordpress --strip-components 1 && \
	rm /tmp/wordpress.tar.gz && \
	chmod +x /var/www/wordpress

	sed -e "s/database_name_here/$WORDPRESS_DB_NAME/g" \
		-e "s/username_here/$WORDPRESS_DB_USER/g" \
		-e "s/password_here/$WORDPRESS_DB_PASSWORD/g" \
		-e "s/localhost/$WORDPRESS_DB_HOST/g" \
		/var/www/wordpress/wp-config-sample.php > /var/www/wordpress/wp-config.php
fi

sed -i \
	-e s/';listen.owner = nobody'/'listen.owner = nginx'/g \
	-e s/';listen.group = nobody'/'listen.group = nginx'/g \
	-e s/'user = nobody'/'user = nginx'/g \
	-e s/'group = nobody'/'group = nginx'/g \
	/etc/php7/php-fpm.d/www.conf

telegraf &

php-fpm7

nginx -g 'daemon off;'
