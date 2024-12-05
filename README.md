# Сгенерируйте конфиг Cloudflare WARP для NekoRay и Karing/Hiddify
Этот bash скрипт сгенерирует конфиг Cloudflare WARP для NekoRay и Karing/Hiddify.

Не стоит выполнять его локально, так как РКН заблокировал запросы для получения конфига. Вместо этого лучше выполнять на удалённых серверах.

## Aeza Terminator
1. Заходим на https://terminator.aeza.net/en/
2. Выбираем **Debian**
3. Вставляем команду:

Для Karing/Hiddify:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_karing.sh)
```
Для Nekoray:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_nekoray.sh)
```
Для AmneziaWG:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/ImMALWARE/bash-warp-generator/main/warp_generator.sh)
```
4. После того, как конфиг сгенерируется, копируем его, либо скачиваем файлом по ссылке и импортируем в нужную програму!👍

Что-то не получилось? Есть вопросы? Пишите в чат: https://t.me/vpn_1_1_1_1_warp 

Сделано для [этого гайда](https://docs.google.com/document/d/1DX4X7t7V4QasQJYbps5D1yNtsK7tqsouSMJH2w4AMOY) 
