Introduction 
============

This projects objective is two fold

 * To provide a Vagrantfile and corresponding cookbook that will setup your Vagrant instance with apache2, rvm, rvm_passenger, postgres and an empty git repo that you can "push to deploy" to
 * To be able to replicate the same configuration above easily on an EC2 instance using the same cookbooks

In other words we want to simulate the ease of deploy of Heroku both in a local repeatable setup via Vagrant and in the clound via EC2. 

Status
------
Very much a work in progress. The cookbook that builds everything up still has hardcoded config values in it and is located in site-cookbooks/rails_app/recipes/default.rb. No work has been done on getting the setup on EC2 as of yet.

Setup 
=====

1. git clone git://github.com/mohangk/chef_rails_app.git
1. bundle install
2. vagrant box add precise64 http://files.vagrantup.com/precise64.box
3. librarian-chef install

In you rails-app

1. Add to Gemfile

 gem 'git-deploy'

2. Add Vagrant as a remote 

 git remote add vagrant ssh://vagrant@localhost:2222/path/to/myapp

3. Add your public key to the vagrant instanct (Probably want to do this as part of the chef setup)

 ssh vagrant@localhost -p 2222 mkdir -p .ssh
 cat ~/.ssh/id_rsa.pub | ssh vagrant@localhost -p2222 'cat >> .ssh/authorized_keys'

3. Setup the remote

 git deploy setup -r vagrant

4. Setup the deploy hook scripts and commit to local repo

 git deploy init

5. Push the code

 git push vagrant master

Stuff to look into

* Adding the rvm::vagrant recipe, not how this will interact with the rest of the setup once we deploy to EC2
* Whether projects should include .rvmrc, as it messes with our rvm::system setup ?

* rvm::vagrant attributes need to be modified

/opt/vagrant_ruby/bin/chef-client
/opt/vagrant_ruby/bin/chef-solo                                                                                                                                          
                                                                                                                                          ~                       
