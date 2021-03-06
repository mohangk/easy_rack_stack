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

Setting up easy_rack_stack
--------------------------

1. git clone git://github.com/newcontext/easy_rack_stack.git
2. bundle install
3. cp Vagrantfile.sample Vagrantfile

  Make relevant changes to the contents of the chef.json section of the Vagrantfile as per [chef-rack_stack attributes](http://github.com/newcontext/chef-rack_stack)
  
4. vagrant box add precise64 http://files.vagrantup.com/precise64.box
5. librarian-chef install

Strating up on Vagrant
----------------------

1. vagrant up

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


Deploying your rails-app to easy_rack_stack Vagrant
---------------------------------------------------

1. Add to Gemfile

 gem 'git-deploy'

2. Add Vagrant as a remote 

 git remote add vagrant ssh://vagrant@localhost:2222/path/to/myapp

4. Setup the remote

 git deploy setup -r vagrant

5. Setup the deploy hook scripts and commit to local repo

 git deploy init

6. Push the code

 git push vagrant local_branch:master 


Stuff to look into
------------------

###Setup related issues

###EC2 specific

* We need something like rvm::vagrant recipe for when we run in an EC2 context.
We need a wrapper for chef-solo and chef-client for when we deploy to EC2. Without 
this once EC2 is spin up with the RVM recipe, subsequent setup.sh runs fail.

 Workaround currently is to install librarian in the globel gemset for the default 
 Ruby

###General

 * When running in Passenger, we can't see the Rails logs. Need to enable 
 PassengeDebugLogFile and PassengerDebugLogLevel to get any logging information

 * nginx support

 * SSL support

 * Postgres 
  - pg_hba.conf permission 
    - we need to be able to override the socket based setting as well
    - is too permissive ?
  -setup user

 * Mail server setup

 * Whether projects should include .rvmrc, as it messes with our rvm::system setup ?

 * Best way to handle different environments ? There exists a configuration option 
in rvm_passenger recipe, and git-deploy uses the RAILS_ENV variable. How would we 
keep (production. staging )

##Deployment related issues

###General

 * Starting and restarting of delayed_jobs taking into RAILS_ENV

 * Setting of RAILS_ENV, especially when SSH-ing into the machine. Ideally for most 
common tasks we go through git-deploy and not need to SSH into the machine.

 * git-deply commit hooks does not seem to work well with RVM setup on the server.
 It does not seem to use to use the right gemset.

 * Git-deploy does not run after_push script on initial push, only on subsequent pushes. 
 Should this be the desired behaviour?

 * Figure out cleanest way to setup database from the local machine instead of ssh-ing
into servers 

###EC2

 * Need to set ENVVAR with IP/domain name of instance. Useful for config files 
