Vagrant.configure("2") do |config|

  config.vm.box = "geerlingguy/centos7"
  config.ssh.username = 'root'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = 'true'
  config.vm.synced_folder "~/zerista", "/zerista"
  config.vm.hostname = "zerista.io"
  
  # Required for vagrant up after the inital vagrant up cmd
  # See this issue on github https://github.com/dotless-de/vagrant-vbguest/issues/333
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #     config.vbguest.auto_update = false
  # end
  
  config.vm.network :private_network, ip: "192.168.50.4"

end
