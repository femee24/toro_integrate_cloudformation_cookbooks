#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


#Configure default folders under assets
%w{data jdbc-pool logs packages system-tmp tmp}.each do |dir|
  directory "#{node[:application][:assets_dir]}/#{dir}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

# Configure default folders under configs
%w{.java custom-web-configs}.each do |dir|
  directory "#{node[:application][:configs_dir]}/#{dir}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

# toro integrate configuration file
template "#{node[:application][:assets_dir]}/data/override.properties" do
        source 'override.properties.erb'
        action :create_if_missing
end

# Configure web directory
directory "#{node[:application][:web_config_dir]}"

# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}.conf" do
        source 'integrate.conf.erb'
        action :create_if_missing
end

# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}.conf" do
        source 'integrate-ftp-stream.conf.erb'
        action :create_if_missing
end
