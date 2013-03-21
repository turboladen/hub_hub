#require 'vagrant-ansible'
require 'screenplay/vagrant'


# Before vagrant can provision, you need to ssh in, copy contents of setup.sh
# and run it.
Vagrant::Config.run do |config|
  config.vm.box     = 'centos58-x86_64'
  config.vm.box_url = 'https://dl.dropbox.com/u/17738575/CentOS-5.8-x86_64.box'

  config.vm.customize ['modifyvm', :id, '--memory', '512']

  # This is only necessary if your CPU does not support VT-x or you run virtualbox
  # inside virtualbox
  #config.vm.customize ['modifyvm', :id, '--vtxvpid', 'off']

  # You can adjust this to the amount of CPUs your system has available
  #config.vm.customize ['modifyvm', :id, '--cpus', '1']

  config.vm.host_name = 'chat-test.mindhub.org'
  config.vm.network :bridged
  config.vm.network :hostonly, '192.168.33.10'
  #config.vm.forward_port 80, 8080

=begin
  config.vm.provision :ansible do |ansible|
    # point Vagrant at the location of your playbook you want to run
    ansible.playbook = 'ansible-playbooks/mindhub-playbook.yml'

    # the Vagrant VM will be put in this host group change this should
    # match the host group in your playbook you want to test
    ansible.hosts = 'mindhub-testers'

    ansible.options = '-vvv'
  end
=end

  config.vm.provision :screenplay do |screenplay|
    screenplay.stage = :default
  end
end
