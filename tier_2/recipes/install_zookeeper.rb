#
# Cookbook Name:: tier_2_saas
# Recipe:: install_zookeeper
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.


directory "#{node[:zookeeper][:installer_dir]}" do
    mode '0755'
    recursive true
end

remote_file "#{node[:zookeeper][:installer_dir]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
	source "https://archive.apache.org/dist/zookeeper/zookeeper-#{node[:zookeeper][:version]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  action :create_if_missing
end

%w{data logs}.each do |dir|
  directory "#{node[:zookeeper][:home_dir]}/#{dir}" do
    mode '0755'
    recursive true
  end
end

ENV['ZOO_LOG_DIR'] = "#{node[:zookeeper][:home_dir]}/logs"

execute "decompress artifact to new instance" do
  command "tar -zxvf #{node[:zookeeper][:installer_dir]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz -C /opt"
end

file "#{node[:zookeeper][:home_dir]}/data/myid" do
  content "#{node[:zookeeper][:id]}"
end
