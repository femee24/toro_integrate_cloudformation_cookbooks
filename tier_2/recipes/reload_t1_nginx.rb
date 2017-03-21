#
# Cookbook Name:: tier_2
# Recipe:: reload_t1_nginx
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

bash 'reload_t1_nginx' do
  code <<-EOH
    aws opsworks create-deployment --region #{node[:infra][:region]} --stack-id #{node[:infra][:t1_stack_id]}  --command '{ "Name": "execute_recipes", "Args": {"recipes": ["tier_1::reload_nginx"]}}' aws opsworks create-deployment --region us-east-1 --stack-id 2b3f6d34-b6f5-44e4-8998-09e6da2b48ba  --command '{ "Name": "execute_recipes", "Args": {"recipes": ["tier_1::reload_nginx"]}}'
    EOH
end
