#
# Cookbook Name:: global
# Recipe:: monitor_resources
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

['perl-Switch', 'perl-DateTime', 'perl-Sys-Syslog', 'perl-LWP-Protocol-https'].each do |p|
package p do
	action :install
  end
end

remote_file "/opt/CloudWatchMonitoringScripts-1.2.1.zip" do
	source "http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip"
	action :create_if_missing
end

execute "unzip_cloudwatchmonitoring_scripts" do
  command "unzip -o /opt/CloudWatchMonitoringScripts-1.2.1.zip -d /opt/"
end

cron 'put_mem_disk_data' do
  action :create
  minute '*/5'
  command "/opt/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron"
end
