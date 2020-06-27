UBUNTU_IMAGE                   = "ubuntu/trusty64"
DEBIAN_IMAGE                   = "debian/buster64"
PROVIDER                       = "virtualbox"
AWX_HOSTNAME                   = "awx"
AWX_ADDRESS                    = "192.168.50.10"
AWX_VERSION                    = ""                # Leave empty for the latest version
GITLAB_HOSTNAME                = "gitlab"
GITLAB_ADDRESS                 = "192.168.50.11"
GITLAB_RUNNERS_HOSTNAME_PREFIX = "runner"
GITLAB_RUNNERS                 = 1
VM_LINUX                       = 1
VM_LINUX_HOSTNAME_PREFIX       = "vmlinux"
VM_LINUX_IMAGE                 = UBUNTU_IMAGE
VM_WINDOWS                     = 0
VM_WINDOWS_HOSTNAME_PREFIX     = "vmwindows"
VM_WINDOWS_IMAGE               = "windows10"


Vagrant.configure("2") do |config|

  config.vm.define "awx" do |awx|
    awx.vm.hostname = AWX_HOSTNAME
    awx.vm.box = DEBIAN_IMAGE
    awx.vm.network "private_network", ip: AWX_ADDRESS
    awx.vm.provision :hosts do |provisioner|
      provisioner.autoconfigure = true
      provisioner.sync_hosts = true
      provisioner.add_host AWX_ADDRESS, [AWX_HOSTNAME]
    end
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
    gitlab.vm.hostname = GITLAB_HOSTNAME
    gitlab.vm.box = DEBIAN_IMAGE
    gitlab.vm.network "private_network", ip: GITLAB_ADDRESS
    gitlab.vm.provision :hosts do |provisioner|
      provisioner.autoconfigure = true
      provisioner.sync_hosts = true
      provisioner.add_host GITLAB_ADDRESS, [GITLAB_HOSTNAME]
    end
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
    vm_name = "#{GITLAB_RUNNERS_HOSTNAME_PREFIX}-#{i}"
    config.vm.define "runner-#{i}" do |runner|
      runner.vm.hostname = vm_name
      runner.vm.box = DEBIAN_IMAGE
      runner.vm.network "private_network", ip: "192.168.50.#{100 + i}"
      runner.vm.provision :hosts do |provisioner|
        provisioner.autoconfigure = true
        provisioner.sync_hosts = true
        provisioner.add_host "192.168.50.#{100 + i}", [vm_name]
      end
      runner.vm.provider PROVIDER do |p|
        p.memory = 512
        p.cpus = 1
      end
      runner.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/gitlab-runner.yml"
      end
    end
  end

  (1..VM_LINUX).each do |i|
    vm_name = "#{VM_LINUX_HOSTNAME_PREFIX}-#{i}"
    config.vm.define vm_name  do |target|
      target.vm.hostname = vm_name
      target.vm.box = VM_LINUX_IMAGE
      target.vm.network "private_network", ip: "192.168.50.#{150 + i}"
      target.vm.provision :hosts do |provisioner|
        provisioner.autoconfigure = true
        provisioner.sync_hosts = true
        provisioner.add_host "192.168.50.#{150 + i}", [vm_name]
      end
      target.vm.provider PROVIDER do |p|
        p.memory = 512
        p.cpus = 1
      end
    end
  end

  (1..VM_WINDOWS).each do |i|
    vm_name = "#{VM_WINDOWS_HOSTNAME_PREFIX}-#{i}"
    config.vm.define vm_name do |target|
      target.vm.hostname = vm_name
      target.vm.box = VM_WINDOWS_IMAGE
      target.vm.guest = :windows
      target.vm.communicator = "winrm"
      target.winrm.username = "IEUser"
      target.winrm.password = "Passw0rd!"
      target.vm.network "private_network", ip: "192.168.50.#{200 + i}"
      target.vm.network "forwarded_port", guest: 3389, host: 3389
      target.vm.provision "shell", name: "Upgrade Powershell", privileged: true, path: "scripts/Upgrade-Powershell.ps1"
      target.vm.provision "shell", name: "Configure remoting for ansible", privileged: true, path: "scripts/ConfigureRemotingForAnsible.ps1"
      target.vm.provision "shell", name: "Install WMF3 hostfix", privileged: true, path: "scripts/Install-WMF3Hotfix.ps1"
      target.vm.provision "shell", name: "Enable ICMP v4", priviliged: true, path: "script/Enable-ICMP-v4.ps1"
      target.vm.provider PROVIDER do |p|
        p.memory = 2048
        p.cpus = 1
      end
    end
  end
end
