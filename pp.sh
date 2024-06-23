#!/bin/bash

domain_name=$DOMAIN_NAME

apt update

if ! nginx -v &>/dev/null; then
    apt install -y nginx
fi

tee /etc/nginx/sites-available/$domain_name <<EOF
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

if [ ! -L /etc/nginx/sites-enabled/$domain_name ]; then
    ln -s /etc/nginx/sites-available/$domain_name /etc/nginx/sites-enabled/
fi

nginx -t
systemctl restart nginx

if [ ! -d /var/www/$domain_name ]; then
    mkdir -p /var/www/$domain_name
fi

if [ ! -f /var/www/$domain_name/1GB.test ]; then
    dd if=/dev/zero of=/var/www/$domain_name/1GB.test bs=1M count=1024
fi

file_url="http://$domain_name/1GB.test"

if [ ! -f webBenchmark_linux_x64 ]; then
    wget -O webBenchmark_linux_x64 https://github.com/maintell/webBenchmark/releases/download/0.6/webBenchmark_linux_x64
    chmod +x webBenchmark_linux_x64
fi

nohup ./webBenchmark_linux_x64 -c 4 -s $file_url > /dev/null 2>&1 &

echo "脚本的 PID 是 $!"
