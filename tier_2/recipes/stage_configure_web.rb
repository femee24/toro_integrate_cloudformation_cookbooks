#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.


# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/stage-#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf" do
        source 'stage-integrate.conf.erb'
end

# HTTP/HTTPS Proxy Configuration
template "#{node[:application][:web_config_dir]}/stage-#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf" do
        source 'stage-integrate-ftp-stream.conf.erb'
end

# bash 'append_integrate_conf' do
#   code <<-EOH
#     #Integrate conf
#     sed -i '/#{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}/d' #{node[:infra][:home_dir]}/vhosts/include.conf
#     echo "include #{node[:application][:web_config_dir]}/#{node[:application][:code]}-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf;" >> #{node[:infra][:home_dir]}/vhosts/include.conf
#     #Integrate ftp conf
#     sed -i 's/#{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}/d' #{node[:infra][:home_dir]}/vhosts/stream.conf
#     echo "include #{node[:application][:web_config_dir]}/#{node[:application][:code]}-ftp-#{node[:application][:name]}-#{node[:opsworks][:instance][:hostname]}.conf;" >> #{node[:infra][:home_dir]}/vhosts/stream.conf
#     EOH
# end

execute "append integrate conf" do
  command "echo 'include '#{node[:application][:web_config_dir]}'/stage-'#{node[:application][:code]}'-'#{node[:application][:name]}'-'#{node[:opsworks][:instance][:hostname]}'.conf;' >> #{node[:infra][:home_dir]}/vhosts/include.conf"
  # only_if "[[ -z $(grep -oE #{node[:application][:code]} #{node[:infra][:home_dir]}/vhosts/include.conf ) ]]"
end

execute "append integrate ftp conf" do
  command "echo 'include '#{node[:application][:web_config_dir]}'/stage-'#{node[:application][:code]}'-ftp-'#{node[:application][:name]}'-'#{node[:opsworks][:instance][:hostname]}'.conf;' >> #{node[:infra][:home_dir]}/vhosts/stream.conf"
  # only_if "[[ -z $(grep -oE #{node[:application][:code]} #{node[:infra][:home_dir]}/vhosts/stream.conf ) ]]"
end
