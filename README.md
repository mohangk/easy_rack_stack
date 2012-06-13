Introduction 
============

This projects objective is two fold

 * To provide a Vagrantfile and corresponding cookbook that will setup your Vagrant 
 instance with apache2, rvm, rvm_passenger, postgres and an empty git repo that you 
 can "push to deploy" to

 * To be able to replicate the same configuration above easily on an EC2 instance 
 using the same cookbooks

In other words we want to simulate the ease of deploy of Heroku both in a local 
repeatable setup via Vagrant and in the clound via EC2. 

Status
------
Very much a work in progress. The cookbook that builds everything up still has 
hardcoded config values in it and is located in site-cookbooks/rails_app/recipes/default.rb. 

Setting up chef-rails-app
------------------------

1. git clone git://github.com/mohangk/chef_rails_app.git
2. rvm ruby-1.9.3@foobar --create --rvmrc
3. bundle install
4. vagrant box add precise64 http://files.vagrantup.com/precise64.box
5. librarian-chef install

In you rails-app
----------------

1. Add to Gemfile

 gem 'git-deploy'

2. Add Vagrant as a remote 

 git remote add vagrant ssh://vagrant@localhost:2222/path/to/myapp

3. Add your public key to the vagrant instance (Probably want to do this as part of the chef setup)

 ssh vagrant@localhost -p 2222 mkdir -p .ssh

 cat ~/.ssh/id_rsa.pub | ssh vagrant@localhost -p2222 'cat >> .ssh/authorized_keys'

4. Setup the remote

 git deploy setup -r vagrant

5. Setup the deploy hook scripts and commit to local repo

 git deploy init

6. Push the code

 git push vagrant local_branch:master 

Spinning up on EC2
------------------

We are basing the work on the https://github.com/nrako/librarian-ec2 project

Ubuntu images on EC2 list http://uec-images.ubuntu.com/precise/current

####EC2 security setup (one time)

1. List exisiting security groups
 
 ec2-describe-group

2. Add SSH, ICMP and HTTP

 ec2-authorize default -p 22
 ec2-authorize default -p 80
 ec2-authorize -P icmp -t -1:-1

####Setting up EC2 instance

1. Spin up an EC2 instance with bootstrap.sh

 Micro instance in ap-southeast-1

 ec2-run-instances ami-a4ca8df6 --region ap-southeast-1 --instance-type t1.micro --key ec2-ap-southeast-1-keypair --user-data-file bootstrap.sh 

 Large instance in ap-souteast-1

 ec2-run-instances ami-2ab8fe78 --region ap-southeast-1 --instance-type m1.large --key ec2-ap-southeast-1-keypair --user-data-file bootstrap.sh 

2. Start the magic

 ./setup.sh IP_ADDRESS ./ ~/.ec2/ec2-ap-southeast-1-keypair

####Upon the EC2 instace being setup

1. Repeat steps 2,3,4 and 6 from the 'In your rails-app' section above, but replace 
all references to your local Vagrant VM with EC2 instead.

####Terminaing the EC2 instance

ec2-terminate-instance INSTANCE_ID 


Stuff to look into
------------------

####Setup related issues

###EC2 specific

* We need something like rvm::vagrant recipe for when we run in an EC2 context.
We need a wrapper for chef-solo and chef-client for when we deploy to EC2. Without 
this once EC2 is spin up with the RVM recipe, subsequent setup.sh runs fail

* On the EC2 instance the 'ubuntu' user is not part of the rvm group, this leads to issues
when trying to do the initial bundle install. Currently we manually add the user as 
follows:
 sudo usermod -a -G rvm ubuntu

###General

* redis support

* nginx support

* SSL support

* Postgres 
  - pg_hba.conf permission 
    - we need to be able to override the socket based setting as well
    - is too permissive ?
  -setup user

* Whether projects should include .rvmrc, as it messes with our rvm::system setup ?

* Best way to handle different environments ? There exists a configuration option 
in rvm_passenger recipe, and git-deploy uses the RAILS_ENV variable. How would we 
keep (production. staging )

####Deployment related issues

* git-deply commit hooks does not seem to work well with RVM setup on the server

* when doing a git-deploy setup on EC2, the permission of the directory is set to 
ubuntu:vagrant, because the remote and ssh user is setup as ubuntu. Need to allow for
it to be done by the vagrant user

* Automate 'bundle install' on git push. git-deploy is suppose to do this but I am not
sure if its working. Maybe it does not work for the first push ?

* Figure out cleanest way to setup database from the local machine instead of ssh-ing
into Vagrant ? 
