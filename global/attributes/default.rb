# ## DEFAULT ATTRIBUTES
#
# Infrastructure Related Attributes
default[:infra][:efs_id]                              = `cat /opt/tmp/efsInstance`.strip
default[:infra][:region]                              = `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`.strip
default[:infra][:internal_elb]                        = `curl -s http://169.254.169.254/latest/meta-data/local-ipv4`.strip
default[:infra][:availability_zone]                   = `curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`.strip
default[:infra][:home_dir]                            = "/datastore"
default[:infra][:log_dir]                             = "#{node[:infra][:home_dir]}/logs"

# Application Related Attributes
default[:application][:name]                          = "integrate"
default[:application][:organization]                  = "yourorganization"
default[:application][:code]                          = "#{node[:application][:organization]}1"
default[:application][:domain]                        = "cloudformation-#{node[:opsworks][:instance][:hostname]}.toro.io"
default[:application][:clients_dir]                   = "#{node[:infra][:home_dir]}/clients"
default[:application][:web_config_dir]                = "#{node[:application][:clients_dir]}/#{node[:application][:organization]}/web_config"
default[:application][:home_dir]                      = "#{node[:application][:clients_dir]}/#{node[:application][:organization]}/apps/#{node[:application][:name]}/#{node[:application][:code]}"
default[:application][:assets_dir]                    = "#{node[:application][:home_dir]}/assets"
default[:application][:configs_dir]                   = "#{node[:application][:home_dir]}/configs"
default[:application][:container_http_port]           = "38080"
default[:application][:container_https_port]          = "38443"
default[:application][:container_ftp_port]            = "20021"
default[:application][:container_debug_port]          = "38000"
default[:application][:debug_port]                    = "8000"
default[:application][:http_port]                     = "8080"
default[:application][:https_port]                    = "8443"
default[:application][:http_proxy_port]               = "80"
default[:application][:https_proxy_port]              = "443"
default[:application][:keystore_file]                 = "keystore"
default[:application][:keystore_pass]                 = "1qaz2wsx"

# Generate Random Password for the Database
db_pw = String.new
while db_pw.length < 16
  db_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

# Database Related Attributes
default[:database][:master_user]                      = `cat #{node[:infra][:home_dir]}/temp/dbuser`.strip
default[:database][:master_pass]                      = `cat #{node[:infra][:home_dir]}/temp/dbpass`.strip
default[:database][:dbhost]                           = `cat #{node[:infra][:home_dir]}/temp/dbhost`.strip
default[:database][:username]                         = "#{node[:application][:code]}"
default[:database][:password]                         = db_pw

# ActiveMQ Related Attributes
default[:activemq][:version]                          = "5.14.0"
default[:activemq][:home_dir]                         = "#{node[:infra][:home_dir]}/apps/activemq"
default[:activemq][:online_servers]                   = `aws opsworks describe-instances --layer-id #{node[:infra][:t2_activemq_layer]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{gsub(/\t/,":61616,tcp://",$0)}1'`.strip
default[:activemq][:jms_url]                          = "failover:tcp://#{node[:activemq][:online_servers]}:61616?CloseAsync=false"
default[:activemq][:jms_file]                         = "remote-activemq"

# Zsookeeper Related Attributes
default[:zookeeper][:version]                         = "3.4.6"
default[:zookeeper][:home_dir]                        = "/opt/zookeeper-#{node[:zookeeper][:version]}"
default[:zookeeper][:installer_dir]                   = "#{node[:infra][:home_dir]}/apps/zookeeper/installer"
default[:zookeeper][:id]                              = "#{node[:opsworks][:instance][:hostname]}".scan( /\d+$/ ).first
default[:zookeeper][:nodes]                           = `aws opsworks describe-instances --region us-east-1 --layer-id #{node[:zookeeper][:layer_id]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{gsub(/\t/,":2181,",$0)}1'`.strip
default[:zookeeper][:cluster]                         =  "#{node[:zookeeper][:nodes]}:2181"

# Solr Related Attributes
default[:solr][:version]                              = "6.2.1"
default[:solr][:home_dir]                             = "/opt/solr-#{node[:solr][:version]}"
default[:solr][:installer_dir]                        = "#{node[:infra][:home_dir]}/apps/solr"
