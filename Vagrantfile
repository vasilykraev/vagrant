# -*- mode: ruby -*-

# TODO
# check OS & nfsd
# .ssh mount
# pma pga zsh
# autoadd domains to /etc/hosts at guest machine

Vagrant::Config.run do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  # config.vm.box = "precise64"
  # config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  # config.vm.box = "lucid32"
  # config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  
  # config.vm.boot_mode = :gui
  
  config.vm.customize ["modifyvm", :id, "--memory", "512"]
  # config.vm.customize ["modifyvm", :id, "--memory", "1024"]

  # host, bridge
  network = "host"

  if network == "host" 
    config.vm.network :hostonly, "33.33.33.10"
    config.vm.forward_port 80, 8000
    config.vm.forward_port 8080, 8080
    config.vm.forward_port 3306, 3306
    config.vm.forward_port 5432, 5432
    config.vm.share_folder "v-data", "/vagrant", ".", :nfs => true
    # config.vm.share_folder "v-ssh", "~/.ssh", "~/.ssh", :nfs => true
  end

  if network == "bridge" 
    config.vm.network :bridged
    config.vm.forward_port 80, 80
    config.vm.share_folder "v-data", "/vagrant", ".", :nfs => false
  end
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"

    if !File.exists?("del_me_to_first_run")
      # puts "It's first run of box, and not be initialized by chef"
      
      chef.log_level = :debug # :info
      # install make & mc, apt
      chef.add_recipe "platform_packages::data_bag"
      chef.add_recipe "apt"

      # lamp/nginx & drupal
      chef.add_role "drupal_lamp"
      # chef.add_role "drupal_nginx"
      chef.add_recipe "drupal::dev"
      
      # python & pgsql + postgis, zsh
      chef.add_role "addition"

      chef.json.merge!({
        :doc_root => '/vagrant/public',
        :mysql => {
          :server_root_password => "root",
          :allow_remote_root => true,
          :bind_address => '0.0.0.0',
        },
        :postgresql => {
          :password => {
            :postgres => "root",
          },
          # configure pgsql to allow remote connections
          :pg_hba => [
            {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
            {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'md5'},
            {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'md5'},
            {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'},
          ],
          :config => {
            :listen_addresses => "*",
            :ssl => false,
          },
          :dbuser => 'air',
          :dbname => 'air',
          :dbpass => 'airpwd',
        },
        :drupal => {
          :hosts => ["air.vm", "dev.vm"],
        },
        :drush => {
         :install_method => 'pear',
         :version => '5.7.0',
        },
        :phing => {
          :version => '2.3.3',
        }
  	  })
      # f = File.open("del_me_to_first_run", "w")
      # f.write("delete this file to initial run chef")
    else
      # puts "Vagrant box has already been initialized"
      chef.add_recipe "dummy"
    end
  end
end
