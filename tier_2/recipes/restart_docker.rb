#
# Cookbook Name:: tier_2
# Recipe:: restart_docker
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

service 'docker' do
  action :restart
end

execute "start ecs-agent" do
  user "root"
  command "docker start ecs-agent"
end
