#!/bin/bash
yum update -y
amazon-linux-extras install php7.4 -y
yum install -y httpd php php-mysqlnd mariadb wget

systemctl enable httpd
systemctl start httpd

cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

###Installation and configuration of CloudWatch Agent 
yum install -y awslogs
cat <<EOF > /etc/awslogs/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/messages]
file = /var/log/messages
log_group_name = /ec2/messages
log_stream_name = {instance_id}
EOF

systemctl start awslogsd
systemctl enable awslogsd