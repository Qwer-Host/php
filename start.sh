#!/bin/ash
rm -rf /home/container/tmp/*

echo "⟳ Starting PHP-FPM..."
/usr/local/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf

echo "⟳ Starting Nginx..."
echo "✓ Successfully started"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -e stderr -p /home/container/ 

while true; do
  read -r line
  if [ "${line}" = "stop" ]; then
    /usr/sbin/nginx -s stop -c /home/container/nginx/nginx.conf -e stderr -p /home/container/
    pkill php-fpm
    rm -rf /tmp/*
    exit 0
  fi
done
