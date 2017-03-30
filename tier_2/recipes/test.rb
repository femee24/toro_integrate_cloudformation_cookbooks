#
# Cookbook Name:: tier_2
# Recipe:: test
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


node['opsworks']['layers']['zookeeper']['instances'].each do |instance, instancedata|
  i = 0
  file("tmp/zoo.cfg").must_include "server.#{i+1}=#{instancedata['private_ip']}:2888:3888"
end
