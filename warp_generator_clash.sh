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
proxies: 
- name: "WARP_"
  type: wireguard
  private-key: ${priv}
  server: 188.114.96.0
  port: 500
  ip: ${client_ipv4}
  public-key: ${peer_pub}
  allowed-ips: ['0.0.0.0/0']
  reserved: [${reservedDec}]
  udp: true
  mtu: 1280
  remote-dns-resolve: true
  dns: [1.1.1.1, 1.0.0.1]
  amnezia-wg-option:
   jc: 120
   jmin: 23
   jmax: 911
   s1: 0
   s2: 0
   h1: 1
   h2: 2
   h4: 3
   h3: 4
   
- name: "WARP in WARP_"
  dialer-proxy: WARP_
  type: wireguard
  private-key: ${wpriv}
  server: 188.114.97.170
  port: 1018
  ip: ${wclient_ipv4}
  public-key: ${peer_pub}
  allowed-ips: ['0.0.0.0/0']
  reserved: [${wreservedDec}]
  udp: true
  mtu: 1200
  remote-dns-resolve: true
  dns: [1.1.1.1, 1.0.0.1]
  
proxy-groups: 
- name: WARP
  type: select
  icon: https://developers.cloudflare.com/_astro/logo.p_ySeMR1.svg
  proxies:
    - WARP_
  url: 'http://speed.cloudflare.com/'
  interval: 300
- name: WARP in WARP
  type: select
  icon: https://developers.cloudflare.com/_astro/logo.p_ySeMR1.svg
  proxies:
    - WARP in WARP_
  url: 'http://speed.cloudflare.com/'
  interval: 300
EOM
)
conf_base64=$(echo -n "${conf}" | base64 -w 0)
clear
echo -e "\n\n\n"
[ -t 1 ] && echo "########## НАЧАЛО КОНФИГА ##########"
echo "${conf}"
[ -t 1 ] && echo "########### КОНЕЦ КОНФИГА ###########"

echo "Иногда конфиг сверху не полный или отсутствует, поэтому лучше скачивайте по ссылке:"
echo -e "\n"
echo "https://immalware.github.io/downloader.html?filename=ClashWARP.yaml&content=${conf_base64}"
echo -e "\n"
echo "Что-то не получилось? Есть вопросы? Пишите в чат: https://t.me/warp_1_1_1_1"
