# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure(2) do |config|
  config.vm.box = "centos7"
  config.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1802_01.Libvirt.box"

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
      master.vm.provision "master", type: "ansible" do |ansible|
        ansible.playbook = "openshift.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "master" => ["master"],
          "config" => ["master"],
        }
      end
      master.vm.provision "config", type: "ansible" do |ansible|
        ansible.playbook = "openshift.yaml"
        ansible.groups = {
          "config" => ["master"],
        }
      end
      master.vm.provision "storage", type: "ansible" do |ansible|
        ansible.playbook = "storage.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "master" => ["master"],
        }
      end
      master.vm.provision "kubevirt", type: "ansible" do |ansible|
        ansible.playbook = "kubevirt.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "master" => ["master"],
        }
      end
      master.vm.provision "miq", type: "ansible" do |ansible|
        ansible.playbook = "miq.yaml"
        ansible.groups = {
          "master" => ["master"],
        }
      end
  end

  config.vm.define "node" do |node|
      node.vm.hostname = "node"
      node.vm.network "private_network", ip: "192.168.201.3"
      node.vm.provider :libvirt do |domain|
          domain.memory = 2048
      end
      node.vm.provision "node", type: "ansible" do |ansible|
        ansible.playbook = "openshift.yaml"
        ansible.groups = {
          "nodes" => ["node"],
          "master" => ["master"],
        }
      end
  end
end
