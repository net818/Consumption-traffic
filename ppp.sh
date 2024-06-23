#!/bin/bash

domain_name=$DOMAIN_NAME
min_wait=$MIN_WAIT
max_wait=$MAX_WAIT

if ! nginx -v &> /dev/null; then
    apt update &> /dev/null
    apt install -y nginx &> /dev/null
fi

if [ ! -f /etc/nginx/sites-available/$domain_name ]; then
    tee /etc/nginx/sites-available/$domain_name > /dev/null <<EOF
server {
    listen 80;
    server_name $domain_name;
    root /var/www/$domain_name;
    index index.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
fi

if [ ! -L /etc/nginx/sites-enabled/$domain_name ]; then
    ln -s /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
fi

nginx -t &> /dev/null
systemctl restart nginx &> /dev/null

if [ ! -d /var/www/$domain_name ]; then
    mkdir -p /var/www/$domain_name
fi
if [ ! -f /var/www/$domain_name/1GB.test ]; then
    dd if=/dev/zero of=/var/www/$domain_name/1GB.test bs=1M count=1024 &> /dev/null
fi

file_url="http://$domain_name/1GB.test"

if [ ! -f webBenchmark_linux_x64 ]; then
    wget -O webBenchmark_linux_x64 https://github.com/maintell/webBenchmark/releases/download/0.6/webBenchmark_linux_x64 &> /dev/null
    chmod +x webBenchmark_linux_x64
fi

while true; do
    nohup ./webBenchmark_linux_x64 -c 4 -s $file_url > /dev/null 2>&1 &
    WEBBENCHMARK_PID=$!

    RANDOM_WAIT_1=$((min_wait + ($RANDOM % max_wait)))
    sleep $RANDOM_WAIT_1
    
    kill $WEBBENCHMARK_PID
    
    RANDOM_WAIT_2=$((min_wait + ($RANDOM % max_wait)))
    sleep $RANDOM_WAIT_2
done
