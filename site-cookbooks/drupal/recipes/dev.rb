include_recipe "build-essential"

package 'git-core' # for dev checkouts
package 'squid3' # for speeding up drush_make

php_pear "xdebug" do
  action :install
end

template "/etc/php5/conf.d/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode 0644
end

php_pear "xhprof" do
  preferred_state "beta"
  action :install
end


# PHING
dc = php_pear_channel "pear.phing.info" do
  action :discover
end

php_pear "phing" do
  preferred_state "stable"
  version node['phing']['version']
  channel dc.channel_name
  action :install
end


# PGSQL DB/USER
include_recipe "postgis2::fix_locale"
include_recipe "postgresql::server"

# execute "create-root-user" do
#     code = <<-EOH
#     sudo -u postgres psql -U postgres -c "select * from pg_user where usename='root'" | grep -c root
#     EOH
#     command "sudo -u postgres createuser -U postgres -s root"
#     not_if code
# end

if (node[:postgresql][:dbuser] != nil)
  execute "create-database-user" do
      code = <<-EOH
      sudo -u postgres psql -U postgres -c "select * from pg_user where usename='#{node[:postgresql][:dbuser]}'" | grep -c #{node[:postgresql][:dbuser]}
      EOH
      command "sudo -u postgres createuser -U postgres -sw #{node[:postgresql][:dbuser]}"
      not_if code
  end
end

if (!node[:postgresql][:dbuser] != nil && node[:postgresql][:dbname] != nil)
  execute "create-database" do
      exists = <<-EOH
      sudo -u postgres psql -U postgres -c "select * from pg_database WHERE datname='#{node[:postgresql][:dbname]}'" | grep -c #{node[:postgresql][:dbname]}
      EOH
      command "sudo -u postgres createdb -U postgres -O #{node[:postgresql][:dbuser]} -T template0 #{node[:postgresql][:dbname]}"
      not_if exists
  end
end