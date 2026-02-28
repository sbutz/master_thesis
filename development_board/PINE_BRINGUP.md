# Bringup of StarPro64 by Pine64

Bringup Guide by lupyuen: https://lupyuen.org/articles/starpro64#eswin-eic7700x-risc-v-soc
RockOs Install Guide: https://docs.rockos.dev/en/docs/installation#pine64-starpro64

USB with FAT32 working --> rootfs image larger than 4G
testing with ext4 filesystem (hint from RockOS Guide)
macos has no ext4 support
workaround:
1. create flat image
2. mount image in docker. create ext4 fs, copy files.
3. write image to usb stick using dd


1. update botloader
2. reset env + save (see rockos guide) -> otherwise random mac address (save + reset should be enough though)
3. partition emmc (should yield 3 parititons)
4. update boot+root paritions
5. reset to boot linux


automate setup:
requirements:
1. power on/off remotely
    smart plug missing
2. access serial console
    serial.sh (str-a, k,y to quit)
    user: debian, pw: debian
3. ssh access
    requires wifi bridge (see markdown file)
4. optional: access to power/serial/ssh from global
    sbutz.duckdns.org

temperature: cat /sys/class/thermal/thermal_zone0/temp (* 1/1000)


