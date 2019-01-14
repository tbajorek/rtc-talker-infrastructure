#!/bin/bash

echo "RTC-Talker builder"
echo "----------------------"
echo ""

cd ../

rm -rf rtc-talker/*

cat ./build/install.template > ./build/unpack.sh
echo "ARCHIVE_DATA:" >> ./build/unpack.sh
echo "- Plik ./unpack.sh został utworzony"

ELEMENTS=`cat ./build/data.txt`
tar -czvf tmp.tar.gz $ELEMENTS >> /dev/null
cat tmp.tar.gz >> ./build/unpack.sh
rm tmp.tar.gz
echo "- Wymagane dane zostały skompresowane i dołączone"

cd build
chmod 770 unpack.sh
echo "- Plik ./unpack.sh jest gotowy do użycia"
