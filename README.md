# Сгенерируйте конфиг Cloudflare WARP для NekoRay
Этот bash скрипт сгенерирует конфиг Cloudflare WARP для NekoRay.

Не стоит выполнять его локально, так как РКН заблокировал запросы для получения конфига. Вместо этого лучше выполнять на удалённых серверах.

## Вариант 1: Aeza Terminator
1. Заходим на https://terminator.aeza.net/en/
2. Выбираем **Debian**
3. Вставляем команду:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_nekoray.sh)
```
4. После того, как конфиг сгенерируется, копируем его, либо скачиваем файлом по ссылке и импортируем в NekoRay!👍

### Другой вопрос?
Напишите в чат: https://t.me/immalware_chat
