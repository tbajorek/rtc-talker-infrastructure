#!/usr/bin/env bash

# instalacja widgetu
echo "Instalacja widgetu..."
echo "---------------------"
cd rtc-talker-widget
yarn install && yarn build
cd ../

# instalacja panelu
echo "Instalacja panelu obsługi..."
echo "----------------------------"
cd rtc-talker-panel
yarn install && yarn build
cd ../

# instalacja serwera sygnalizacji
echo "Instalacja serwera sygnalizacji..."
echo "----------------------------------"
cd rtc-talker-sigserver
yarn install && yarn build && yarn start
