#
# Cookbook Name:: tier_2
# Recipe:: reload_t1_nginx
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

execute "configure mysql" do
  user "root"
  command 'aws opsworks create-deployment --region #{node[:infra][:region]} --stack-id #{node[:infra][:t1_stack_id]}  --command '{ "Name": "execute_recipes", "Args": {"recipes": ["tier_1::reload_nginx"]}}''
end
