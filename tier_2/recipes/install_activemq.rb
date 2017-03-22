#
# Cookbook Name:: tier_2
# Recipe:: install_activemq
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

%w{configs installer instances}.each do |dir|
  directory "#{node[:activemq][:home_dir]}/#{dir}" do
    mode '0755'
    recursive true
  end
end

directory "#{node[:activemq][:home_dir]}/instances/#{node[:opsworks][:instance][:hostname]}" do
  recursive true
end

remote_file "#{node[:activemq][:home_dir]}/installer/apache-activemq-#{node[:activemq][:version]}-bin.tar.gz" do
  source "https://archive.apache.org/dist/activemq/#{node[:activemq][:version]}/apache-activemq-#{node[:activemq][:version]}-bin.tar.gz"
  action :create_if_missing
end

execute "decompress artifact to new instance" do
  command "tar -zxvf #{node[:activemq][:home_dir]}/installer/apache-activemq-#{node[:activemq][:version]}-bin.tar.gz -C /datastore/apps/activemq/instances/#{node[:opsworks][:instance][:hostname]} --strip-components=1"
end

execute "start activemq" do
  command "sh #{node[:activemq][:home_dir]}/instances/#{node[:opsworks][:instance][:hostname]}/bin/activemq start"
end
