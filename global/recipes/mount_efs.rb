#
# Cookbook Name:: global
# Recipe:: mount_efs
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

directory '/datastore' do
  owner 'root'
  group 'root'
  action :create
end

bash 'mount_efs' do
  user 'root'
  cwd '/'
  code <<-EOH
	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-077bbe4e.efs.us-east-1.amazonaws.com:/ /datastore
  EOH
end
