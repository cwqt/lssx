#!/bin/bash
rm -rf src/
moonc -t src .
cp -R libs src/libs
cp -R assets src/assets
cd src/
zip -9 -r lssx.love .
mv lssx.love ../
cd ../
