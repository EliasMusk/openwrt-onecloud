#!/bin/bash


mkdir -p files/etc/openclash/core
mkdir -p files/etc/profile.d
mkdir -p files/etc/config
mkdir -p files/root

CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/dev/clash-linux-armv7.tar.gz"
CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/dev/premium\?ref\=core | grep download_url | grep armv7 | awk -F '"' '{print $4}')
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/meta/clash-linux-armv7.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
kr_URL="https://raw.githubusercontent.com/shiyu1314/openwrt-onecloud/main/sh/1.sh"
xx_URL="https://raw.githubusercontent.com/shiyu1314/openwrt-onecloud/main/sh/30-sysinfo.sh"

wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $kr_URL > files/root/1.sh
wget -qO- $xx_URL > files/etc/profile.d/30-sysinfo.sh

chmod +x files/etc/openclash/core/clash*
chmod +x files/root/1.sh

echo "# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

bash /root/1.sh
exit 0">files/etc/rc.local

echo "
config defaults
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'ACCEPT'

config zone
	option name 'lan'
	option network 'lan utun'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'ACCEPT'

config include 'openclash'
	option type 'script'
	option path '/var/etc/openclash.include'

config zone 'docker'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'ACCEPT'
	option name 'docker'
	list network 'docker'

">files/etc/config/firewall
