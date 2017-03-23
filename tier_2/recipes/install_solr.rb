#
# Cookbook Name:: tier_2_saas
# Recipe:: install_solr
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.

directory "#{node[:zookeeper][:installer_dir]}" do
    mode '0755'
    recursive true
end

remote_file "/datastore/apps/solr/installer/solr-#{node[:solr][:version]}.tgz" do
	source "http://archive.apache.org/dist/lucene/solr/#{node[:solr][:version]}/solr-#{node[:solr][:version]}.tgz"
	action :create_if_missing
end

execute "start solr" do
  command "#{node[:solr][:home_dir]}/bin/solr start -cloud -z #{node[:zookeeper][:cluster]}"
end
