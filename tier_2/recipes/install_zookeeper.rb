#
# Cookbook Name:: tier_2_saas
# Recipe:: install_zookeeper
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.


directory "#{node[:zookeeper][:installer_dir]}" do
    mode '0755'
    recursive true
end

remote_file "#{node[:zookeeper][:installer_dir]}/zookeeper-#{node[:zookeeper][:ver]}.tar.gz" do
	source "http://www-us.apache.org/dist/zookeeper/zookeeper-#{node[:zookeeper][:ver]}/zookeeper-#{node[:zookeeper][:ver]}.tar.gz"
	action :create_if_missing
end

%w{data logs}.each do |dir|
  directory "#{node[:zookeeper][:home_dir]}/#{dir}" do
    mode '0755'
    recursive true
  end
end

ENV['ZOO_LOG_DIR'] = "#{node[:zookeeper][:home_dir]}/logs"

file "#{node[:zookeeper][:home_dir]}/myid" do
  content "#{node[:zookeeper][:id]}"
end

execute "decompress artifact to new instance" do
  command "tar -zxvf #{node[:zookeeper][:installer_dir]}/zookeeper-#{node[:zookeeper][:ver]}.tar.gz -C /opt"
end

# toro integrate configuration file
template "#{node[:zookeeper][:home_dir]}/conf/zoo.cfg" do
        source 'zoo.cfg.erb'
end

execute "start zookeeper" do
  command "#{node[:infra][:home_dir]}/bin/zkServer.sh start"
end
