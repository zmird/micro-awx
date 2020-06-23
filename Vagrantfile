# Works only on debian for the moment
IMAGE_NAME = "debian/buster64"
PROVIDER = "virtualbox"
NETWORK = "192.168.50"
AWX_ADDRESS = "#{NETWORK}.10"
AWX_VERSION = ""
GITLAB_ADDRESS = "#{NETWORK}.11"
GITLAB_RUNNERS = 1
TARGET_MACHINES = 2


Vagrant.configure("2") do |config|
  config.vm.box = IMAGE_NAME

  config.vm.define "awx" do |awx|
    awx.vm.network "private_network", ip: AWX_ADDRESS
    awx.vm.provider PROVIDER do |p|
      p.memory = 2048
      p.cpus = 2
    end
    awx.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/awx.yml"
      ansible.extra_vars = {
        awx_version: AWX_VERSION
      }
    end
  end

  config.vm.define "gitlab" do |gitlab|
    gitlab.vm.network "private_network", ip: GITLAB_ADDRESS
    gitlab.vm.provider PROVIDER do |p|
      p.memory = 2560
      p.cpus = 2
    end
    gitlab.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/gitlab.yml"
      ansible.extra_vars = {
        gitlab_host: GITLAB_ADDRESS
      }
    end
  end

  (1..GITLAB_RUNNERS).each do |i|
    config.vm.define "runner-#{i}" do |runner|
      runner.vm.network "private_network", ip: "#{NETWORK}.#{i + 50}"
      runner.vm.provider PROVIDER do |p|
        p.memory = 512
        p.cpus = 1
      end
    end
  end

  (1..TARGET_MACHINES).each do |i|
    config.vm.define "target-#{i}" do |target|
      target.vm.network "private_network", ip: "#{NETWORK}.#{i + 100}"
      target.vm.provider PROVIDER do |p|
        p.memory = 512
        p.cpus = 1
      end
    end
  end
end
