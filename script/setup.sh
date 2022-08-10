#! /bin/bash -e
cp /etc/apt/sources.list /etc/apt/sources.list.0
sed -i -E "s|http://us.|http://|g" /etc/apt/sources.list
apt-get update -y
apt-get install software-properties-common 
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible sshpass -y
ansible-galaxy collection install community.general
mkdir -p /home/vagrant/log/
pushd /vagrant
cp provisioning/ansible/templates/ansible.cfg /etc/ansible/ansible.cfg
chmod 644 /etc/ansible/ansible.cfg
printf "####### Starting Playbook ######"
# sudo ansible-playbook provisioning/ansible/master-playbook.yml --extra-vars "node_ip=192.168.50.10"
ansible-playbook provisioning/ansible/$playbook.yml
popd
usermod -aG docker vagrant
printf "####### You should be ok to configure microk8s ######"