#!/bin/bash
# Author: wuseman

# FLASHING
# Wholeflash flashtest 
echo "Creating wholeflash backup"
echo "--------------------------------------------------------------------"
flashtest  export 000000 16777216
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0x000000-0xffffff.wholeflash
echo "Done.."
echo ""

# Boot / Bootloader
echo "Creating bootloader backup.."
echo "--------------------------------------------------------------------"
flashtest export 000000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0x000000-0x040000.bootloader
echo "Done.."
echo ""

# Image / Main  image
echo "Creating main image backup.."
echo "--------------------------------------------------------------------"
flashtest export 040000 10485760
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0x040000-0xa40000.mainimage
echo "Done.."
echo ""

echo "Creating image/subject backup.."
echo "--------------------------------------------------------------------"
# Image / Subject  image
flashtest export a40000 3932160
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xa40000-0xe00000.subjectimage
echo "Done.."
echo ""

# Curcfg / Curcent  config
echo "Creating Curcfg backup.."
echo "--------------------------------------------------------------------"
flashtest export e00000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xe00000-0xe40000.currentconfig
echo "Done.."
echo ""

# Faccfg / Factury  config
echo "Creating faccfg backup.."
echo "--------------------------------------------------------------------"
flashtest export e40000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xe40000-0xe80000.factoryconfig
echo "Done.."
echo ""

# Tmpcfg / Temp  config
echo "Creating tmpcfg backup.."
echo "--------------------------------------------------------------------"
flashtest export e80000 524288
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xe80000-0xf00000.tempconfig
echo "Done.."
echo ""

# Fixcfg / Fixed  config
echo "Creating fixcfg backup.."
echo "--------------------------------------------------------------------"
flashtest export f00000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xf00000-0xf40000.fixedconfig
echo "Done.."
echo ""

# Logcfg / Log  config
echo "Creating logcfg backup.."
echo "--------------------------------------------------------------------"
flashtest export f40000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xf40000-0xf80000.logconfig
echo "Done.."
echo ""

# TR069 / TR069  cert
echo "Creating TR069 cert backup.."
echo "--------------------------------------------------------------------"
flashtest export f80000 262144

mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xf80000-0xfc0000.tr069cert
echo "Done.."
echo ""

# Nvram / Nvram
echo "Creating nvram backup.."
echo "--------------------------------------------------------------------"
flashtest export fc0000 262144
mv /tmp/flashinfo.bin /mnt/usb2_1/huawei_b593_backup/flash0xfc0000-0xffffff.nvram
echo "Done.."
echo ""

# Nandflash
echo "Creating nandflash backup via dd, this might going to take a while.."
echo "--------------------------------------------------------------------"
dd bs=4k if=/dev/nandflash of=/mnt/usb2_1/huawei_b593_backup/nandflash.bin
echo "Done.."
echo ""

# Creating a README file
echo "Creating a README file with important data"
echo "--------------------------------------------------------------------"
flashtest info > /mnt/usb2_1/huawei_b593_backup/README.txt
echo "Done.."
echo ""


# Backup NVRAM
echo "Creating a nvram info backup
echo "--------------------------------------------------------------------"
nvram show > /mnt/usb2_1/huawei_b593_backup/NVRAM_README.txt
echo "Done.."
echo ""

echo "Backup Done :-)"
