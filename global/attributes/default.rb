### DEFAULT ATTRIBUTES

# Infrastructure Related Attributes
default[:infra][:efs_id]                              = shell_out("cat /opt/tmp/efsInstance")
default[:infra][:region]                              = shell_out("curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region")
default[:infra][:availability_zone]                   = open("http://169.254.169.254/latest/meta-data/placement/availability-zone")
default[:infra][:home_dir]                            = "/datastore"
default[:infra][:log_dir]                             = "#{node[:infra][:home_dir]}/logs"

# Application Related Attributes
default[:application][:name]                          = "integrate"
default[:application][:organization]                  = "yourorganization"
default[:application][:code]                          = "yourorganization1"
default[:application][:clients_dir]                   = "#{node[:infra][:home_dir]}/clients"
default[:application][:home_dir]                      = "#{node[:application][:clients_dir]}/#{node[:application][:organization]}/apps/#{node[:application][:name]}/#{node}[:application][:code]"
default[:application][:assets_dir]                    = "#{node[:application][:home_dir]}/assets"
default[:application][:configs_dir]                   = "#{node[:application][:home_dir]}/configs"

# Generate Random Password for the Database
db_pw = String.new
while db_pw.length < 20
  db_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end

# Database Related Attributes
default[:database][:master_user]                      = shell_out("cat #{node[:infra][:home_dir]}/temp/dbuser")
default[:database][:master_pass]                      = shell_out("cat #{node[:infra][:home_dir]}/temp/dbpass")
default[:database][:host]                             = shell_out("cat #{node[:infra][:home_dir]}/temp/dbhost")
default[:database][:username]                         = "#{node[:application][:code]}"
default[:database][:password]                         = db_pw
default[:database][:tracker_db]                       = "#{node[:application][:code]}_tracker"
default[:database][:coder_db]                         = "#{node[:application][:code]}_coder"

#
