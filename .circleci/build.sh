#!/usr/bin/env bash
echo "Cloning dependencies"
git clone --depth=1 https://github.com/Hycon-Devices/device_xiaomi_ysl device/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/vendor_xiaomi_ysl vendor/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/kernel_xiaomi_ysl kernel/xiaomi/ysl

echo "Done"

. build/envsetup.sh
lunch aosp_ysl-userdebug
mka bacon -j8
