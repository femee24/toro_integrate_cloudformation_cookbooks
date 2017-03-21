#
# Cookbook Name:: tier_1
# Recipe:: reload_nginx
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

service 'nginx' do
	action [:reload]
end
