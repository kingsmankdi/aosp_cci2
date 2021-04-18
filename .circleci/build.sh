#!/usr/bin/env bash

apt install sudo

echo -e "number of cores?"
nproc --all

mkdir hycon 
cd hycon
echo -e "Installing Google Repo"
mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo


echo -e "Installing tools"
sudo apt install -y \
    adb autoconf automake axel bc bison build-essential \
    ccache clang cmake expat fastboot flex g++ \
    g++-multilib gawk gcc gcc-multilib gnupg gperf \
    htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev \
    libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev \
    libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils '^lzma.*' lzop \
    maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
    pngquant python2.7 python-all-dev re2c schedtool squashfs-tools subversion \
    texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
    libxml-simple-perl apt-utils \

apt install -y openjdk-8-jdk apache2 bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python libncurses5


echo "-------------- Installing scripts----------------"
git clone https://github.com/dustxyz/scripts
cd scripts
bash setup/android_build_env.sh
cd ..


echo "----------------Repo Sync----------------"
repo init -u https://github.com/HyconOS/manifest.git -b eleven
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

echo " -----------Cloning Hals--------------"
rm -rf vendor/codeaurora/telephony hardware/qcom-caf/msm8996/media hardware/qcom-caf/msm8996/audio hardware/qcom-caf/msm8996/display && git clone https://github.com/wave-project/vendor_codeaurora_telephony --depth=1 --single-branch vendor/codeaurora/telephony/ && git clone --single-branch https://github.com/Jabiyeff/android_hardware_qcom_media hardware/qcom-caf/msm8996/media && git clone --single-branch https://github.com/Jabiyeff/android_hardware_qcom_display hardware/qcom-caf/msm8996/display &&  git clone https://github.com/LineageOS/android_hardware_qcom_audio --single-branch -b lineage-18.1-caf-msm8996 hardware/qcom-caf/msm8996/audio

echo "Cloning dependencies"
git clone --depth=1 https://github.com/Hycon-Devices/device_xiaomi_ysl device/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/vendor_xiaomi_ysl vendor/xiaomi/ysl
git clone --depth=1 https://github.com/Hycon-Devices/kernel_xiaomi_ysl kernel/xiaomi/ysl

echo "Done"

echo -e "Building"
bash build/envsetup.sh
echo " BUILD/ENVSETUP.SH CALLED"
lunch aosp_ysl-userdebug & mka bacon -j$(nproc --all)
