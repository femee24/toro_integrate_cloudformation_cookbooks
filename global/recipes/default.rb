#
# Cookbook Name:: global
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

# Create default folders
%w{apps clients configs lab library logs temp trash vhosts}.each do |dir|
  directory "/datastore/#{dir}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end