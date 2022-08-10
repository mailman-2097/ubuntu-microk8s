# -*- mode: ruby -*-
# vi: set ft=ruby :
# Ubuntu Box : 20220803.0.0
# VBox : 6.1.34

IMAGE_NAME = "ubuntu/focal64"
VAGRANTFILE_API_VERSION = "2"
N = 1

$dns_script = <<-SCRIPT
echo "192.168.50.10 microk8s" >> /etc/hosts
echo "192.168.50.11 node1" >> /etc/hosts
echo "192.168.50.12 node2" >> /etc/hosts
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.insert_key = false
    config.vm.boot_timeout = 900

    config.vm.define "microk8s" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "microk8s"
        master.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant"
        master.vm.network :forwarded_port, guest: 22, host: 10022, id: "ssh"
		master.vm.provision "shell", path: "script/setup.sh", env: {"node_ip" => "192.168.50.10", "playbook" => "master-playbook"}
        master.vm.provision "shell", inline: $dns_script
        master.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", 6000]
            vb.customize ["modifyvm", :id, "--name", "microk8s"]
            vb.customize ["modifyvm", :id, "--cpus", "2"]
        end
    end

    (1..N).each do |i|
        config.vm.define "node#{i}", autostart: false do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node#{i}"
            node.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant"
            node.vm.network :forwarded_port, guest: 22, host: "100#{i + 22}", id: "ssh"
            node.vm.provision "shell", path: "script/setup.sh", env: {"node_ip" => "192.168.50.#{i + 10}", "playbook" => "node-playbook"}
            node.vm.provision "shell", inline: $dns_script
            node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", 3072]
                vb.customize ["modifyvm", :id, "--name", "node#{i}"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
            end
        end
    end
end