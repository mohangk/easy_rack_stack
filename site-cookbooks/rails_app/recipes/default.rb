include_recipe 'apache2::default'
include_recipe 'apache2::mod_expires'
include_recipe 'rvm::system'
#might need to be removed before deploying on EC2
include_recipe 'rvm::vagrant'
include_recipe 'rvm_passenger::default'
include_recipe 'rvm_passenger::apache2'
