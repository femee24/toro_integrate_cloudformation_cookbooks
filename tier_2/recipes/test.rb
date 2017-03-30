#
# Cookbook Name:: tier_2
# Recipe:: test
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

i = 0

node['opsworks']['layers']['zookeeper']['instances'].each do |instance, instancedata|
  i = i + 1
  open("tmp/zoo.cfg", 'a') { |f| f <<  "server.#{i}=#{instancedata['private_ip']}:2888:3888\n" }
  log "current server number is #{i}"
end
