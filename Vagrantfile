require 'vagrant-ansible'


# Need to ssh in and do:
# $ cd /usr/src
# $ sudo wget http://dl.fedoraproject.org/pub/epel/5Server/x86_64/epel-release-5-4.noarch.rpm
# $ sudo rpm -ivh epel-release-5-4.noarch.rpm
# $ sudo yum update
# $ sudo yum install python26 python26-PyYAML python26-paramiko python26-jinja2 python-simplejson
Vagrant::Config.run do |config|
  config.vm.box     = "centos58-x86_64"
  config.vm.box_url = "https://dl.dropbox.com/u/17738575/CentOS-5.8-x86_64.box"

  config.vm.customize ["modifyvm", :id, "--memory", "512"]

  # This is only necessary if your CPU does not support VT-x or you run virtualbox
  # inside virtualbox
  #config.vm.customize ["modifyvm", :id, "--vtxvpid", "off"]

  # You can adjust this to the amount of CPUs your system has available
  #config.vm.customize ["modifyvm", :id, "--cpus", "1"]

  config.vm.host_name = "chat.mindhub.org"
  config.vm.network :bridged
  config.vm.network :hostonly, "192.168.33.10"
  config.vm.forward_port 80, 8080

  config.vm.provision :ansible do |ansible|
    # point Vagrant at the location of your playbook you want to run
    ansible.playbook = "ansible-playbooks/mindhub-playbook.yml"

    # the Vagrant VM will be put in this host group change this should
    # match the host group in your playbook you want to test
    ansible.hosts = "mindhub-testers"
  end
end
