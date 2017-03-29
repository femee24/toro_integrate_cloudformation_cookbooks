#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


node['opsworks']['layers']['zookeeper']['instances'].each do |instance, instancedata|
    log "Private IP: #{instancedata['private_ip']}"
  end
end
