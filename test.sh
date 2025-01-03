#!/bin/bash

clear
mkdir -p ~/.cloudshell && touch ~/.cloudshell/no-apt-get-warning # Для Google Cloud Shell, но лучше там не выполнять
echo "Установка зависимостей..."
apt update -y && apt install sudo -y # Для Aeza Terminator, там sudo не установлен по умолчанию
sudo apt-get update -y --fix-missing && sudo apt-get install wireguard-tools jq wget -y --fix-missing # Update второй раз, если sudo установлен и обязателен (в строке выше не сработал)

priv="${1:-$(wg genkey)}"
pub="${2:-$(echo "${priv}" | wg pubkey)}"
api="https://api.cloudflareclient.com/v0i1909051800"
ins() { curl -s -H 'user-agent:' -H 'content-type: application/json' -X "$1" "${api}/$2" "${@:3}"; }
sec() { ins "$1" "$2" -H "authorization: Bearer $3" "${@:4}"; }
response=$(ins POST "reg" -d "{\"install_id\":\"\",\"tos\":\"$(date -u +%FT%T.000Z)\",\"key\":\"${pub}\",\"fcm_token\":\"\",\"type\":\"ios\",\"locale\":\"en_US\"}")

id=$(echo "$response" | jq -r '.result.id')
token=$(echo "$response" | jq -r '.result.token')
response=$(sec PATCH "reg/${id}" "$token" -d '{"warp_enabled":true}')
peer_pub=$(echo "$response" | jq -r '.result.config.peers[0].public_key')
peer_endpoint=$(echo "$response" | jq -r '.result.config.peers[0].endpoint.host')
client_ipv4=$(echo "$response" | jq -r '.result.config.interface.addresses.v4')
client_ipv6=$(echo "$response" | jq -r '.result.config.interface.addresses.v6')

reserved64=$(echo "$response" | jq -r '.result.config.client_id')
reservedHex=$(echo "$reserved64" | base64 -d | hexdump -v -e '/1 "%02x\n"')
reservedDec=$(printf '%s\n' "${reservedHex}" | while read -r hex; do printf "%d, " "0x${hex}"; done)
reservedDec="[${reservedDec%, }]"
reservedHex=$(echo "${reservedHex}" | awk 'BEGIN { ORS=""; print "0x" } { print }')

wpriv="${1:-$(wg genkey)}"
wpub="${2:-$(echo "${wpriv}" | wg pubkey)}"
ins() { curl -s -H 'user-agent:' -H 'content-type: application/json' -X "$1" "${api}/$2" "${@:3}"; }
sec() { ins "$1" "$2" -H "authorization: Bearer $3" "${@:4}"; }
wresponse=$(ins POST "reg" -d "{\"install_id\":\"\",\"tos\":\"$(date -u +%FT%T.000Z)\",\"key\":\"${wpub}\",\"fcm_token\":\"\",\"type\":\"ios\",\"locale\":\"en_US\"}")

wid=$(echo "$wresponse" | jq -r '.result.id')
wtoken=$(echo "$wresponse" | jq -r '.result.token')
wresponse=$(sec PATCH "reg/${wid}" "$wtoken" -d '{"warp_enabled":true}')
wclient_ipv4=$(echo "$wresponse" | jq -r '.result.config.interface.addresses.v4')
wclient_ipv6=$(echo "$wresponse" | jq -r '.result.config.interface.addresses.v6')
wreserved64=$(echo "$wresponse" | jq -r '.result.config.client_id')
wreservedHex=$(echo "$wreserved64" | base64 -d | hexdump -v -e '/1 "%02x\n"')
wreservedDec=$(printf '%s\n' "${wreservedHex}" | while read -r hex; do printf "%d, " "0x${hex}"; done)
wreservedDec="[${wreservedDec%, }]"
wreservedHex=$(echo "${wreservedHex}" | awk 'BEGIN { ORS=""; print "0x" } { print }')






conf=$(cat <<-EOM
{
  "outbounds":   [
{
"tag": "WARP",
"reserved": ${reservedDec},
"mtu": 1280,
"fake_packets": "5-10",
"fake_packets_size": "40-100",
"fake_packets_delay": "20-250",
"fake_packets_mode": "m4",
"private_key": "${priv}",
"type": "wireguard",
"local_address": ["${client_ipv4}/24", "${client_ipv6}/128"],
"peer_public_key": "${peer_pub}",
"server": "188.114.97.170",
"server_port": 2408
},
  {
   "type": "wireguard",
   "tag": "WARP in WARP",
   "detour": "WARP",
   "local_address": ["${wclient_ipv4}/24", "${wclient_ipv6}/128"],
   "private_key": "${wpriv}",
   "peer_public_key": "${peer_pub}",
   "reserved": ${wreservedDec},
   "mtu": 1280,
   "server": "188.114.97.170",
   "server_port": 1018
  }
  ]
}
EOM
)

conf_base64=$(echo -n "${conf}" | base64 -w 0)
echo -e "\n\n\n"
[ -t 1 ] && echo "########## НАЧАЛО КОНФИГА ##########"
echo "${conf}"
[ -t 1 ] && echo "########### КОНЕЦ КОНФИГА ###########"

echo "Иногда конфиг сверху не полный или отсутствует, поэтому лучше скачивайте по ссылке:"
echo -e "\n"
echo "https://immalware.github.io/downloader.html?filename=WARP.conf&content=${conf_base64}"
echo -e "\n"
echo "Что-то не получилось? Есть вопросы? Пишите в чат: https://t.me/vpn_1_1_1_1_warp"
