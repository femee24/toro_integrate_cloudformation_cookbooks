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
  bash 'add_zookeeper_nodes' do
    code <<-EOH
      echo server.#{i}=#{instancedata['private_ip']}:2888:3888 >> #{node[:zookeeper][:home_dir]}/conf/zoo.cfg
    EOH
end
end


#Start Zookeeper
execute "start zookeeper" do
  command "#{node[:zookeeper][:home_dir]}/bin/zkServer.sh restart"
end
