#!/bin/bash
(apt update && apt install -y cbm lsof) > /dev/null 2>&1

service=$(sudo lsof -i :80 | awk 'NR==2 {print $1}')

if [ ! -z "$service" ]; then
    if [ "$service" != "nginx" ]; then
        echo "80端口被$service占用，现在将其终止..."
        pid=$(sudo lsof -i :80 -t)
        sudo kill -9 $pid
    else
       
fi

echo "温馨提示!"
echo "请在脚本执行完后输入 cbm 命令检查 eth0 网卡是否在跑流量"
read -p "请输入已解析本机IP的域名或者本机IP(如果等下流量没在跑就给域名套上CF): " domain_name

echo "请选择安装选项："
echo "1. 直接24小时持续跑流量"
echo "2. 随机时间跑流量"
read -p "请输入你的选择（1或2）：" choice

case $choice in
    1)
        echo "正在下载 '直接24小时持续跑流量' 脚本..."
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
