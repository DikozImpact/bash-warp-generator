# Сгенерируйте конфиг Cloudflare WARP для AmneziaWG/NekoRay/Exclave/Husi/Karing/Hiddify/Clash
## Вариант 1: Через сайт 
https://generator-warp-config.vercel.app

## Вариант 2: Aeza Terminator
Этот bash скрипт сгенерирует конфиг Cloudflare WARP для AmneziaWG/NekoRay/Exclave/Husi/Karing/Hiddify/Clash.

Не стоит выполнять его локально, так как РКН заблокировал запросы для получения конфига. Вместо этого лучше выполнять на удалённых серверах.

1. Заходим на https://terminator.aeza.net/en/
2. Выбираем **Debian**
3. Вставляем команду:
4. После того, как конфиг сгенерируется, копируем его, либо скачиваем файлом по ссылке и импортируем в нужную програму!👍

Для AmneziaWG:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/ImMALWARE/bash-warp-generator/main/warp_generator.sh)
```
Для Karing/Hiddify:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_karing.sh)
```
Для NekoRay/Exclave:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_neko.sh)
```
Для Husi:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_husi.sh)
```
Для Clash:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_generator_clash.sh)
```
Дополнительный вариант
WARP in WARP для Karing/Hiddify:
```bash
bash <(wget -qO- https://raw.githubusercontent.com/DikozImpact/bash-warp-generator/refs/heads/patch-1/warp_in_warp.sh)
```

> [!NOTE]
> Что-то не получилось? Есть вопросы? Пишите в чат: https://t.me/warp_1_1_1_1
>
> Сделано для [этого гайда](https://help-guide.notion.site/1f72684dab0d8092a582ed6328632d06) 
