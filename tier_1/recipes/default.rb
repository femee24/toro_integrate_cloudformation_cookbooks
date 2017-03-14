#
# Cookbook Name:: tier_1
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

package 'nginx'
package 'nginx-mod-stream'

file '/datastore/vhosts/include.conf' do
  action [:touch]
end

file '/datastore/vhosts/stream.conf' do
  action [:touch]
end

template '/etc/nginx/nginx.conf' do
        source 'nginx.conf.erb'
end

service 'nginx' do
	action [:restart]
end

execute "Register Server's Public IP" do
  user "root"
  command "echo $(curl http://169.254.169.254/latest/meta-data/public-ipv4) > /datastore/configs/saas/web-servers"
end

execute "Register Server's Private IP" do
  user "root"
  command "echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) > /datastore/configs/saas/web-servers-private"
end
