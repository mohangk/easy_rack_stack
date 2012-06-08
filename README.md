0. rvm ruby-1.9.3@foobar --create --rvmrc
1. bundle install
2. vagrant init precise64 http://files.vagrantup.com/precise64.box
3. librarian-chef install

In you rails-app

1. Add to Gemfile

gem 'git-deploy'

2. Add Vagrant as a remote 

 git remote add vagrant ssh://vagrant@localhost:2222/path/to/myapp

Stuff to look into

* Adding the rvm::vagrant recipe, not how this will interact with the rest of the setup once we deploy to EC2
* Whether projects should include .rvmrc, as it messes with our rvm::system setup ?

* rvm::vagrant attributes need to be modified

/opt/vagrant_ruby/bin/chef-client
/opt/vagrant_ruby/bin/chef-solo                                                                                                                                          
                                                                                                                                          ~                       
