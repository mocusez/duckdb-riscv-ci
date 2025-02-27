ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
echo -e "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile /dev/null" >> ~/.ssh/config
chmod 600 ~/.ssh/config
sshpass -p 'root' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 -q root@localhost "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo $(cat ~/.ssh/id_rsa.pub) >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" > /dev/null 2>&1
