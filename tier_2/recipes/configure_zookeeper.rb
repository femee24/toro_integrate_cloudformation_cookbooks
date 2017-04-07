#
# Cookbook Name:: tier_2
# Recipe:: configure_zookeeper
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

# toro integrate configuration file
template "#{node[:zookeeper][:home_dir]}/conf/zoo.cfg" do
        source 'zoo.cfg.erb'
end

# add current running zookeeper instances
i = 0
node['opsworks']['layers']['zookeeper']['instances'].each do |instance, instancedata|
  i = i + 1
  open("#{node[:zookeeper][:home_dir]}/conf/zoo.cfg", 'a') { |f| f <<  "server.#{i}=#{instancedata['private_ip']}:2888:3888\n" }
end


#Start Zookeeper
execute "start zookeeper" do
  command "#{node[:zookeeper][:home_dir]}/bin/zkServer.sh restart"
end
