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

bash 'append_integrate_conf' do
  code <<-EOH
    #Integrate conf
    perl -i -ne "print unless /#{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}-/" #{node[:infra][:home_dir]}/vhosts/include.conf
    echo "include #{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf;" >> #{node[:infra][:home_dir]}/vhosts/include.conf
    #Integrate ftp conf
    perl -i -ne "print unless /#{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}-/" #{node[:infra][:home_dir]}/vhosts/stream.conf
    echo "include #{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf;" >> #{node[:infra][:home_dir]}/vhosts/stream.conf
    EOH
end
