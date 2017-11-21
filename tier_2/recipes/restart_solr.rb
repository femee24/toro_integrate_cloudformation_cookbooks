#
# Cookbook Name:: tier_2_saas
# Recipe:: restart_solr
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.

execute "restart solr" do
  command "#{node[:solr][:home_dir]}/bin/solr restart -cloud -z #{node[:zookeeper][:cluster]} -h #{node[:instance][:domain_name]}"
end
