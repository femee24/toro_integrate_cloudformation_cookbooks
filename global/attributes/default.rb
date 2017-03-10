# ## DEFAULT ATTRIBUTES
#
# Infrastructure Related Attributes
default[:infra][:efs_id]                              = `cat /opt/tmp/efsInstance`
default[:infra][:region]                              = `curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
default[:infra][:availability_zone]                   = open("http://169.254.169.254/latest/meta-data/placement/availability-zone")
default[:infra][:home_dir]                            = "/datastore"
default[:infra][:log_dir]                             = "#{node[:infra][:home_dir]}/logs"
default[:infra][:internal_elb]                        = `curl -s http://169.254.169.254/latest/meta-data/local-ipv4`


# Application Related Attributes
default[:application][:name]                          = "integrate"
default[:application][:organization]                  = "yourorganization"
default[:application][:code]                          = "yourorganization1"
default[:application][:domain]                        = "cloudformation.toro.io"
default[:application][:clients_dir]                   = "#{node[:infra][:home_dir]}/clients"
default[:application][:web_config_dir]                = "#{node[:application][:clients_dir]}/#{node[:application][:organization]}/web_config"
default[:application][:home_dir]                      = "#{node[:application][:clients_dir]}/#{node[:application][:organization]}/apps/#{node[:application][:name]}/#{node[:application][:code]}"
default[:application][:assets_dir]                    = "#{node[:application][:home_dir]}/assets"
default[:application][:configs_dir]                   = "#{node[:application][:home_dir]}/configs"
default[:application][:container_http_port]           = "30001"
default[:application][:container_https_port]          = "30002"
default[:application][:container_ftp_port]            = "20001"
default[:application][:container_debug_port]          = "30003"
default[:application][:debug_port]                    = "8000"
default[:application][:http_port]                     = "8080"
default[:application][:https_port]                    = "8443"
default[:application][:http_proxy_port]               = "80"
default[:application][:https_proxy_port]              = "443"
default[:application][:keystore_file]                 = "8080"
default[:application][:keystore_pass]                 = "8080"

# Generate Random Password for the Database
db_pw = String.new
while db_pw.length < 16
  db_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

# Database Related Attributes
default[:database][:master_user]                      = `cat #{node[:infra][:home_dir]}/temp/dbuser`
default[:database][:master_pass]                      = `cat #{node[:infra][:home_dir]}/temp/dbpass`
#default[:database][:host]                             = `cat #{node[:infra][:home_dir]}/temp/dbhost`
default[:database][:host]                             = IO.read("#{node[:infra][:home_dir]}/temp/dbhost")
default[:database][:username]                         = "#{node[:application][:code]}"
default[:database][:password]                         = db_pw

#
