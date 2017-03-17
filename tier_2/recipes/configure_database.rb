#
# Cookbook Name:: tier_2
# Recipe:: configure_database
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

# Generate database configuration
%w{tracker coder}.each do |db|
template "#{node[:application][:assets_dir]}/jdbc-pool/#{db}.xml" do
        source 'jdbc.xml.erb'
        variables(
            :database => "#{db}"
        )
        action :create_if_missing
   end
end

# Configure external database
cookbook_file "/tmp/configure_mysql.sh" do
  source "configure_mysql.sh"
  mode 0755
  owner "root"
end

execute "configure mysql" do
  user "root"
  command "sh /tmp/configure_mysql.sh '#{node[:application][:code]}' '#{node[:database][:username]}' '#{node[:database][:password]}' '#{node[:database][:master_user]}' '#{node[:database][:master_pass]}' '#{node[:database][:dbhost]}' > #{node[:infra][:log_dir]}/mysql-config-${HOSTNAME}-$(date +'%m-%d-%y').log"
end
