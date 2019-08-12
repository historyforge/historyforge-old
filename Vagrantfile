# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.define "thc-historyforge-18"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 3000, host: 3000

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder ".", "/srv/mapwarper"

  # Host only network so that NFS will work
  config.vm.network :private_network, ip: "192.168.44.44"

  config.vm.synced_folder '.', '/app', type: "nfs"
  # This uses uid and gid of the user that started vagrant.
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.vm.provision :shell, :path => "lib/vagrant/provision.sh"
  # config.vm.provision :shell, :path => "lib/vagrant/provision_rvm.sh", args: "stable", privileged: false
  # config.vm.provision :shell, :path => "lib/vagrant/provision_ruby.sh", privileged: false
  # config.vm.provision :shell, :path => "lib/vagrant/provision_app.sh"


  #you may want to alter this
  config.vm.provider :virtualbox do |v|
    v.memory = 2048
    v.cpus = 2
    # v.customize [ "modifyvm", :id, "--hwvirtex", "off", "--memory", 1024, "--cpus", 1 ]
  end


end
