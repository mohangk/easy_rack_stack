# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file precise64.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "precise64.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding 
  # some recipes and/or roles.
  #
   config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = ["cookbooks"]
     #chef.roles_path = "../my-recipes/roles"
     chef.data_bags_path = "data_bags"
     #chef.add_recipe "chef_rails_app"
     chef.add_recipe "chef-rack_stack"
     #chef.add_role "web"
  
     # You may also specify custom JSON attributes:
     chef.json = {
      'postgresql' => {
        'hba' => [
          { 'method' => 'trust', 'address' => '127.0.0.1/32' },
          { 'method' => 'trust', 'address' => '::1/128' }
       ]},
      'rvm' => {
        'default_ruby' => 'ruby-1.9.2',
        'group_users' => ['www-data','nctx'],
        'global_gems' => [{ 'name' => 'librarian'}],
        'rvmrc' => { 'rvm_trust_rvmrcs_flag' => 1 },
        'vagrant' => { 
          'system_chef_client' => '/opt/vagrant_ruby/bin/chef-client', 
          'system_chef_solo' => '/opt/vagrant_ruby/bin/chef-solo'
         } 
       },
      'rack_stack' => {
        'appname' => 'Pie',
        'environment' => 'production',
        'deploy_user_authorized_key' => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDskEpOM1FM6BJTlTGC+XfKAFaYuOkOzDgLLxU1QP+orlbL+YECxXy9m2dLy5sV+gpLtarP1Gc7+ei7O4zQXWhCPQYmEWvfvD2qjiTEUwKEV5EGZ58gwNr/BsQ7aUdsi7QQleRSF1k2Z+DR872YRCNvu6BCTqje8HvSjNubFVEkdBOJJTxTGsUeJn41BZ4AXI9BsNXsOPEGll2VaWyVXco16310ovu56kk0KvVNAvJ97vdrVSriMD6xmmy/Bo/l0H0kAz6KhQkxlWkhBZePsEBt4Z3vcTD+YzkfP1OzQ87DHt4C+HKz7tVy45vri4ObPHS3SfMOzb/cPDRF4s9Dzarl nctx@loyang',
        'deploy_user' => 'nctx',
        'deploy_group' => 'nctx'
       }, 
      'user' => {
        'create_user_group' => 'true'
       }
     }
     require 'json'
     open('dna.json', 'w') do |f|
       chef.json[:run_list] = chef.run_list
       f.write chef.json.to_json
     end 
   end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # IF you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
