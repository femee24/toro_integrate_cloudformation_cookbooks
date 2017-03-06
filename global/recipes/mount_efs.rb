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
  	efsId=$(cat /opt/tmp/efsInstance)
  	region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
  	availabilityZone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${availabilityZone}.${efsId}.efs.${region}.amazonaws.com:/ /datastore
  EOH
end
