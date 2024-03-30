#!/bin/bash

read -p "请输入您的域名: " domain_name

echo "请选择安装选项："
echo "1. 直接跑流量"
echo "2. 随机时间跑流量"
read -p "请输入你的选择（1或2）：" choice

case $choice in
    1)
        echo "正在下载 '直接跑流量' 脚本..."
        url="https://github.com/net818/Consumption-traffic/raw/main/pp.sh"
        script_file="script.sh"
        wget -O $script_file $url
        chmod +x $script_file
        export DOMAIN_NAME=$domain_name
        ./$script_file
        ;;
    2)
        echo "正在下载 '随机时间跑流量' 脚本..."
        url="https://github.com/net818/Consumption-traffic/raw/main/ppp.sh"
        read -p "请输入最小等待时间（秒）: " min_wait
        read -p "请输入最大等待时间（秒）: " max_wait
        script_file="script.sh"
        wget -O $script_file $url
        chmod +x $script_file
        export DOMAIN_NAME=$domain_name
        export MIN_WAIT=$min_wait
        export MAX_WAIT=$max_wait
        nohup ./$script_file > /dev/null 2>&1 &
        echo "$script_file 的 PID 是 $!"
        ;;
    *)
        echo "无效的输入。退出安装。"
        exit 1
        ;;
esac
