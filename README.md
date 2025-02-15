# Сгенерируйте конфиг Cloudflare WARP для NekoRay/Exclave/Karing/Hiddify/AmneziaWG
## Вариант 1: Через сайт 
https://generator-warp.vercel.app/ 

(Сайт находится на бесплатном хостинге с ограничениями на трафик в месяц, поэтому иногда может быть недоступен)

## Вариант 2: Aeza Terminator
Этот bash скрипт сгенерирует конфиг Cloudflare WARP для NekoRay/Exclave/Karing/Hiddify/AmneziaWG.

Не стоит выполнять его локально, так как РКН заблокировал запросы для получения конфига. Вместо этого лучше выполнять на удалённых серверах.

1. Заходим на https://terminator.aeza.net/en/
2. Выбираем **Debian**
3. Вставляем команду:

Для Karing/Hiddify:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_karing.sh)
```
Для NekoRay/Exclave:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_neko.sh)
```
Для AmneziaWG:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/ImMALWARE/bash-warp-generator/main/warp_generator.sh)
```
Дополнительный вариант
WARP in WARP для Karing/Hiddify:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_in_warp.sh)
```
4. После того, как конфиг сгенерируется, копируем его, либо скачиваем файлом по ссылке и импортируем в нужную програму!👍


Что-то не получилось? Есть вопросы? Пишите в чат: https://t.me/warp_1_1_1_1

Сделано для [этого гайда](https://docs.google.com/document/d/1DX4X7t7V4QasQJYbps5D1yNtsK7tqsouSMJH2w4AMOY) 
