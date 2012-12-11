php_pear_channel "components.ez.no" do
  action :discover
end

# phing
dc = php_pear_channel "pear.phing.info" do
  action :discover
end
php_pear "phing" do
  preferred_state "stable"
  version node['phing']['version']
  channel dc.channel_name
  options "-a"
  action :install
end

php_pear "imagick" do
  preferred_state "beta"
  action :install
  ignore_failure true
end

# PHP_Depend
dc = php_pear_channel "pear.pdepend.org" do
  action :discover
end
php_pear "PHP_Depend" do
  channel dc.channel_name
  action :install
  ignore_failure true
end

# PMD
dc = php_pear_channel "pear.phpmd.org" do
  action :discover
end
php_pear "PHP_PMD" do
  channel dc.channel_name
  action :install
end

# Dependencies for PHPUnit
dc = php_pear_channel "pear.netpirates.net" do
  action :discover
end
php_pear "fDOMDocument" do
  channel dc.channel_name
  action :install
end
dc = php_pear_channel "pear.symfony.com" do
  action :discover
end
php_pear "Finder" do
  channel dc.channel_name
  action :install
end

# PHPUnit
dc = php_pear_channel "pear.phpunit.de" do
  action :discover
end
php_pear "phpcpd" do
  channel dc.channel_name
  action :install
end
php_pear "phploc" do
  channel dc.channel_name
  action :install
end
php_pear "PHP_CodeBrowser" do
  channel dc.channel_name
  action :install
  options "-a"
end

# Other
php_pear "PHPDocumentor" do
  action :install
end
php_pear "PHP_CodeSniffer" do
  action :install
  options "-a"
end
php_pear "HTTP_Request2" do
  action :install
end