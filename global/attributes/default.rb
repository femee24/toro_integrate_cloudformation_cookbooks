# ## DEFAULT ATTRIBUTES
#
# Infrastructure Related Attributes
default[:infra][:efs_id]                              = `cat /opt/tmp/efsInstance`.strip
default[:infra][:region]                              = `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`.strip
default[:infra][:internal_elb]                        = `curl -s http://169.254.169.254/latest/meta-data/local-ipv4`.strip
default[:infra][:availability_zone]                   = `curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`.strip
default[:infra][:home_dir]                            = "/datastore"
default[:infra][:log_dir]                             = "#{node[:infra][:home_dir]}/logs"
default[:infra][:ssl_name]                            = "star.toro.io"

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
default[:application][:packages_dir]                  = "/clients/#{node[:application][:organization]}/apps/#{node[:application][:name]}/#{node[:application][:code]}/assets/packages"
default[:application][:packages]                      = "/integrate/packages"
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
default[:application][:ssl_chain]                     = `aws iam get-server-certificate --server-certificate-name #{node[:infra][:ssl_name]} --query 'ServerCertificate.CertificateChain' --output text`.strip
default[:application][:ssl_body]                      = `aws iam get-server-certificate --server-certificate-name #{node[:infra][:ssl_name]} --query 'ServerCertificate.CertificateBody' --output text`.strip

# Generate Random Password for the Database
db_pw = String.new
while db_pw.length < 16
  db_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

# Database Related Attributes
default[:database][:master_user]                      = "company"
default[:database][:master_pass]                      = "heresyourpassword"
default[:database][:dbhost]                           = `cat #{node[:infra][:home_dir]}/temp/dbhost`.strip
default[:database][:username]                         = "#{node[:application][:code]}"
default[:database][:password]                         = db_pw

# ActiveMQ Related Attributes
default[:activemq][:version]                          = "5.14.0"
default[:activemq][:home_dir]                         = "#{node[:infra][:home_dir]}/apps/activemq"
default[:activemq][:online_servers]                   = `aws opsworks describe-instances --layer-id #{node[:infra][:t2_activemq_layer]} --region #{node[:infra][:region]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{gsub(/\t/,":61616,tcp://",$0)}1'`.strip
default[:activemq][:jms_url]                          = "failover:tcp://#{node[:activemq][:online_servers]}:61616?CloseAsync=false"
default[:activemq][:jms_file]                         = "remote-activemq"

# Zookeeper Related Attributes
default[:zookeeper][:version]                         = "3.4.12"
default[:zookeeper][:port]                            = "2181"
default[:zookeeper][:home_dir]                        = "/opt/zookeeper-#{node[:zookeeper][:version]}"
default[:zookeeper][:installer_dir]                   = "#{node[:infra][:home_dir]}/apps/zookeeper/installer"
default[:zookeeper][:id]                              = "#{node[:opsworks][:instance][:hostname]}".scan( /\d+$/ ).first
default[:zookeeper][:first_ip]                        = `aws opsworks describe-instances --region #{node[:infra][:region]} --layer-id #{node[:infra][:t2_zookeeper_layer]} --region #{node[:infra][:region]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{print $1}'`.strip
default[:zookeeper][:nodes]                           = `aws opsworks describe-instances --region #{node[:infra][:region]} --layer-id #{node[:infra][:t2_zookeeper_layer]} --region #{node[:infra][:region]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{gsub(/\t/,":#{node[:zookeeper][:port]},",$0)}1'`.strip
default[:zookeeper][:cluster]                         =  "#{node[:zookeeper][:nodes]}:#{node[:zookeeper][:port]}"

# Solr Related Attributes
default[:solr][:version]                              = "6.6.2"
default[:solr][:port]                                 = "8983"
default[:solr][:home_dir]                             = "/opt/solr-#{node[:solr][:version]}"
default[:solr][:installer_dir]                        = "#{node[:infra][:home_dir]}/apps/solr/installer"
default[:solr][:config_dir]                           = "#{node[:infra][:home_dir]}/apps/solr/configs"
default[:solr][:first_ip]                             = `aws opsworks describe-instances --region #{node[:infra][:region]} --layer-id #{node[:infra][:t2_solr_layer]} --query "Instances[?Status=='online'].PrivateIp" --output text | awk '{print $1}'`.strip
default[:solr][:mode]                                 = "cloud"
default[:solr][:shards]                               = "1"
default[:solr][:max_shards]                           = "1"
default[:solr][:replication_factor]                   = "1"
default[:solr][:router]                               = "compositeId"
