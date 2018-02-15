# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure(2) do |config|
  config.vm.box = "centos7"
  config.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1608_01.LibVirt.box"

  if Vagrant.has_plugin?("vagrant-cachier") then
      config.cache.scope = :machine
      config.cache.auto_detect = false
      config.cache.enable :dnf
      config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=4', 'tcp']
    }
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider :libvirt do |domain|
      domain.cpus = 2
      domain.nested = true  # enable nested virtualization
      domain.cpu_mode = "host-model"
  end
 
  config.ssh.insert_key = false

  config.vm.define "master" do |master|
      master.vm.hostname = "master"
      master.vm.network "private_network", ip: "192.168.201.2"
      master.vm.provider :libvirt do |domain|
          domain.memory = 3096
      end
      master.vm.provision "master", type: "ansible", run: "never" do |ansible|
        ansible.playbook = "demo.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "masters" => ["master"],
        }
      end
      master.vm.provision "provisioner", type: "ansible", run: "never" do |ansible|
        ansible.playbook = "provisioner.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "masters" => ["master"],
        }
      end
  end

  config.vm.define "node" do |node|
      node.vm.hostname = "node"
      node.vm.network "private_network", ip: "192.168.201.3"
      node.vm.provider :libvirt do |domain|
          domain.memory = 2048
      end
      node.vm.provision "node", type: "ansible", run: "never" do |ansible|
        ansible.playbook = "demo.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "masters" => ["master"],
        }
      end
  end
end
