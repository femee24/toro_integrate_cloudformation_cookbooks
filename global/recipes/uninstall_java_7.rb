#
# Cookbook Name:: tier_2_saas
# Recipe:: uninstall_java_7
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.

yum_package 'java-1.7.0-openjdk' do
  action :remove
end
