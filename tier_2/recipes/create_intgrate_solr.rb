#
# Cookbook Name:: tier_2_saas
# Recipe:: upload_solr_schema
#
# Copyright (c) 2016 TORO Limited, All Rights Reserved.

%w{tracker invoke_monitor}.each do |schema|
  execute "create tracker collection" do
    command "curl -s http://#{node[:solr][:first_ip]}:#{node[:solr][:port]}/admin/collections?action=CREATE&name=#{node[:application][:code]}_core_#{schema}&numShards=#{node[:solr][:shards]}&replicationFactor=#{node[:solr][:port]}&maxShardsPerNode=#{node[:solr][:max_shards]}&createNodeSet=nodelist&collection.configName=core_#{schema}"
  end
end
