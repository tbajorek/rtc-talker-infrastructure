#!/usr/bin/env bash

cd rtc-talker-rest
echo "Oczekiwanie na bazę danych" && sleep 3m &&
echo "Instalacja zaleźności" &&
composer install &&
echo "Inicjalizacja schematu bazy danych" &&
php vendor/bin/doctrine orm:schema-tool:update --force &&
echo "Serwer REST został poprawnie zainstalowany"
cd ../

/usr/bin/php-fpm