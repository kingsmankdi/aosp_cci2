#!/usr/bin/env bash

echo "Installing Google Repo"
mkdir -p .bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > .bin/repo
chmod a+rx .bin/repo

echo "Repo sync"
repo init -u https://github.com/HyconOS/manifest -b eleven
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

echo "Cloning dependencies"
git clone --depth=1 https://github.com/Hycon-Devices/device_xiaomi_ysl device/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/vendor_xiaomi_ysl vendor/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/kernel_xiaomi_ysl kernel/xiaomi/ysl

echo "Done"

. build/envsetup.sh
lunch aosp_ysl-userdebug
mka bacon -j8
