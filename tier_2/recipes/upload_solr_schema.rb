#
# Cookbook Name:: tier_2_saas
# Recipe:: upload_solr_schema
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.

%w{tracker invoke_monitor}.each do |schema|
  directory "#{node[:solr][:config_dir]}/#{schema}/conf" do
    mode "0755"
    recursive true
  end

  template "#{node[:solr][:config_dir]}/#{schema}/conf/solrconfig.xml" do
    source "#{schema}-solrconfig.xml.erb"
  end

  template "#{node[:solr][:config_dir]}/#{schema}/conf/schema.xml" do
    source "#{schema}-schema.xml.erb"
  end

  execute "upload integrate schemas" do
    command "#{node[:solr][:home_dir]}/server/scripts/cloud-scripts/zkcli.sh -cmd upconfig -zkhost #{node[:zookeeper][:first_ip]}:#{node[:zookeeper][:port]} -confname core_#{schema} -confdir #{node[:solr][:config_dir]}/#{schema}/conf"
    not_if { ::File.exists? "[/datastore/tmp/#{schema}]" }
  end

  file "/datastore/tmp/#{schema}" do
    action :touch
  end

end
