include_recipe "apt"
include_recipe "java"

apt_repository "jenkins" do
  uri "http://pkg.jenkins-ci.org/debian"
  key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
  components ["binary/"]
  action :add
end

package "jenkins"

service "jenkins" do
  supports [:stop, :start, :restart]
  action [:start, :enable]
end

# execute :install_jenkins_plugins do
#   command "
# wget http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin analysis-core;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin analysis-collector;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin checkstyle;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin dry;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin phing;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin plot;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin pmd;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin timestamper;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin console-column-plugin;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin compact-columns;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin build-timeout;
# java -jar jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart;
# "
#   not_if "test -e jenkins-cli.jar"
#   action :run
# end

