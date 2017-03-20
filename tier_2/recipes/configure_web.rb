#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf" do
        source 'integrate.conf.erb'
        action :create_if_missing
end

# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf" do
        source 'integrate-ftp-stream.conf.erb'
        action :create_if_missing
end

execute "append integrate conf" do
  user "root"
  command "echo #{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf >> #{node[:infra][:home_dir]}/vhosts/include.conf"
end

execute "append integrate ftp conf" do
  user "root"
  command "echo #{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf >> #{node[:infra][:home_dir]}/vhosts/stream.conf"
end
