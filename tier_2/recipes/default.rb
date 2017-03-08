#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

include_attribute "global"

#Configuring default folders under assets
%w{data jdbc-pool logs packages system-tmp tmp}.each do |dir|
  directory "#{node[:application][:assets_dir]}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

#Configuring default folders under configs
%w{.java custom-web-configs}.each do |dir|
  directory "#{node[:application][:configs_dir]}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

