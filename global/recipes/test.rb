#
# Cookbook Name:: tier_1
# Recipe:: test
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

execute "Test Custom JSON" do
  user "root"
  command "echo #{node[:infra][:efs_id]} > /tmp/test"
end
