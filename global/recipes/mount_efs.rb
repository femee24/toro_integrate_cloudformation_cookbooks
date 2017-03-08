#
# Cookbook Name:: global
# Recipe:: mount_efs
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

home_dir = "/datastore"
efs_id = shell_out("cat /opt/tmp/efsInstance")
region = shell_out("curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region")
availability_zone = open("http://169.254.169.254/latest/meta-data/placement/availability-zone")

directory "#{home_dir}" do
  owner 'root'
  group 'root'
  action :create
end

mount "#{home_dir}" do
  device "#{availability_zone}.#{efs_id}.efs.#{region}.amazonaws.com:/"
  fstype 'nfs'
  options 'rw,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2'
  action [:mount]
end