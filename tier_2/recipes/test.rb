#
# Cookbook Name:: tier_2
# Recipe:: test
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


#"#{node[:opsworks][:layers][:zookeeper][:instances]}".each do |instance, instancedata|
#    log "Private IP: #{node[:opsworks][:layers][:zookeeper][:instances][instance][:private_ip]}"
#  end
#end
ec2 = "zookeeper1"

file "/tmp/zk" do
  content "#{node[:opsworks][:layers][:zookeeper][:instances][ec2][:ip]}"
end
