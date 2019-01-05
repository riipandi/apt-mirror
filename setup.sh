#!/usr/bin/env bash
#
# If you using WSL, don't forget change:
#
#  from: /var/spool/apt-mirror
#    to: /mnt/d/apt-mirror
#

apt install -y curl git apt-mirror screen rsync htop nginx genisoimage

perl -pi -e 's#(.*sudo.*ALL=)(.*)#${1}(ALL) NOPASSWD:ALL#' /etc/sudoers

chmod +x /var/spool/apt-mirror/var/*.sh
touch /etc/apt/mirror.list ; nano $_

# Cron run every midnight
cat > /etc/cron.d/apt-mirror <<EOF
* 0 * * * /usr/bin/apt-mirror &>/var/log/apt-mirror.cron.log &
# @reboot /usr/bin/apt-mirror &>/var/log/apt-mirror.cron.log &
EOF

# Nginx virtualhost
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    server_name _;
    index index.html;
    root /var/www;
    autoindex on;

    location / { try_files \$uri \$uri/ =404; }
    location ~ /\.ht { deny all; }

    location /ubuntu { alias /var/spool/apt-mirror/mirror/kartolo.sby.datautama.net.id/ubuntu; }
    location /debian { alias /var/spool/apt-mirror/mirror/kartolo.sby.datautama.net.id/debian; }
    location /debian-security { alias /var/spool/apt-mirror/mirror/kartolo.sby.datautama.net.id/debian-security; }
}
EOF

# Test running in background
nohup /usr/bin/apt-mirror &>/var/log/apt-mirror.log &

# Check disk usage
du -hsc /var/spool/apt-mirror/

# Crate iso image
genisoimage -v -r -V APTREPO -o apt-repo.iso /var/spool/apt-mirror/
