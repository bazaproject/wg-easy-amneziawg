# WG-Easy 15.3.0 + AmneziaWG

Рабочая установка WG-Easy 15.3.0 с поддержкой AmneziaWG/AWG.

## Установка

```bash
git clone https://github.com/bazaproject/wg-easy-amneziawg.git
cd wg-easy-amneziawg
chmod +x install.sh
./install.sh
```

## Проверка

```bash
docker ps
docker logs --tail=100 wg-easy
docker exec -it wg-easy awg show
```
