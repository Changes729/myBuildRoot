#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# Install SSH key
mkdir -p ${TARGET_DIR}/root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDy4iUQO+D59gdidyyHdz4abB62GbaltGALHkl4JBXTSi09SRAGgetABgX03zveQfAFLKgo00Umo/XCjRjbOSUSOVqhvSzfhukilhJQxn14V2nBPNr6r2MB+NV+VJVb01EyOeE7uzzpruQVrc56ZMEO4fboGSvFyPvgk94KGv4Azl5jKr4xWkQh2UjmaEcM9OXfHgHyqrOxWE3s6EO2tqCXUm/ipip8tzBi56gk13oX5jDuHU2gP0SZPY92nb8c5jf5HZK97DfVKz1hJxQu+4rTz86kimgzpHhTNj72Ksw6ixGHdcU4YJg6Ilf6OIcAOZsDAIeYIKgw2uZIr9ImYIgj6wp2hsAWvON1vY1VOtrY+O2Mtuk9NLYw7KlenI5EIkEC/TAcCWqVJUNr7/rP+UoUFt3tqXZGHpUEY09fF8PFAD2gdjE+UE9Twm/D0dbSnQXxk17MV3QWaF1HKoAdJFmlqsgu874RqA22kF5Odc7LuWYEhbm3z+jHhdgoUm2IKCc= changes729@163.com" > ${TARGET_DIR}/root/.ssh/authorized_keys

# Config Network
mkdir -p ${TARGET_DIR}/etc/wpa_supplicant
touch ${TARGET_DIR}/etc/wpa_supplicant/_boxVPN.conf
wpa_passphrase _boxVPN Wifimima8nengwei0 > ${TARGET_DIR}/etc/wpa_supplicant/_boxVPN.conf
cat > ${TARGET_DIR}/etc/dhcpcd.conf << EOF
interface eth0
static ip_address=192.168.3.241/24
static routers=192.168.3.1
static domain_name_servers=192.168.3.1 8.8.8.8

# fallback to static profile on eth0
interface eth0
fallback static_eth0
EOF

# Update sshd config
sed -i -e '/^#PermitRootLogin.*/c\PermitRootLogin yes' ${TARGET_DIR}/etc/ssh/sshd_config
sed -i -e '/^#PubkeyAuthentication.*/c\PubkeyAuthentication yes' ${TARGET_DIR}/etc/ssh/sshd_config

# Startup Script
cat > ${TARGET_DIR}/root/.bash_profile << EOF
if [[ ! $DISPLAY && $XDG_VTNR -le 3 ]]; then  # le 3 可以支持多显示器
    case $(ps -o comm= -p $PPID) in
        sshd | */sshd) echo "Welcome ssh." ;; # 判断终端是否是ssh登陆的
	    *) echo "Hello RaspberryPi" ;;
    esac
fi
EOF
