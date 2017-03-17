#
# Cookbook Name:: global
# Recipe:: mount_efs
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

directory "#{node[:infra][:home_dir]}" do
  owner 'root'
  group 'root'
  action :create
end

mount "#{node[:infra][:home_dir]}" do
  device "#{node[:infra][:efs_id]}.efs.#{node[:infra][:region]}.amazonaws.com:/"
  fstype 'nfs'
  options 'rw,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2'
  action [:mount]
end
