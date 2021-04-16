#!/usr/bin/env bash

mkdir hycon
cd hycon

echo "Installing sudo"
apt-get install sudo

echo "Installing repo"
sudo apt-get install repo

echo "Installing scripts"
git clone https://github.com/akhilnarang/scripts
cd scripts 
chmod +x setup/android_build_env.sh
./setup/android_build_env.sh
cd ..

echo -e "sync"
repo init -u https://github.com/HyconOS/manifest -b eleven
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

echo "Cloning dependencies"
git clone --depth=1 https://github.com/Hycon-Devices/device_xiaomi_ysl device/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/vendor_xiaomi_ysl vendor/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/kernel_xiaomi_ysl kernel/xiaomi/ysl

echo "Done"

. build/envsetup.sh
lunch aosp_ysl-userdebug
mka bacon -j9
