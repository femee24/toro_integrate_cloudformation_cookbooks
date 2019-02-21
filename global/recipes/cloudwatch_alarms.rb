#
# Cookbook Name:: global
# Recipe:: cloudwatch_alarms
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


Statistic= "Average"
Unit= "Percent"
Threshold= 80
Period= 300
ComparisonOperator= "GreaterThanThreshold"
EvaluationPeriods= 1
Actions="#{node[:infra][:notification_email]}"
NameSpace= "System/Linux"
Dimensions= "Name=InstanceId,Value=#{node[:opsworks][:instance][:aws_instance_id]}"
NameRegion= "#{node[:opsworks][:instance][:region]}"

['cpu', 'mem', 'disk'].each do |check|
  case [check]
    when ["cpu"]
      AlarmName= "#{node[:opsworks][:instance][:hostname]}-#{node[:infra][:resource_group]}-#{check}-gt-#{Threshold}-5min"
      MetricName= "CPUUtilization"
      NameSpace= "AWS/EC2"
    when ["mem"]
      AlarmName= "#{node[:opsworks][:instance][:hostname]}-#{node[:infra][:resource_group]}-#{check}-gt-#{Threshold}-5min"
      MetricName= "MemoryUtilization"
      NameSpace= "System/Linux"
    when ["disk"]
      AlarmName= "#{node[:opsworks][:instance][:hostname]}-#{node[:infra][:resource_group]}-#{check}-gt-#{Threshold}-5min"
      MetricName= "DiskSpaceUtilization"
      NameSpace= "System/Linux"
      Dimensions= "Name=Filesystem,Value=/dev/xvda1 Name=MountPath,Value=/ Name=InstanceId,Value=#{node[:opsworks][:instance][:aws_instance_id]}"

    else
      log "wrong utilization parameter"
  end
  execute check do
    command "aws cloudwatch put-metric-alarm --region #{NameRegion} --alarm-name #{AlarmName} --metric-name #{MetricName} --namespace #{NameSpace} --statistic #{Statistic} --unit #{Unit} --period #{Period} --threshold #{Threshold} --comparison-operator #{ComparisonOperator} --dimensions #{Dimensions} --evaluation-periods #{EvaluationPeriods} --ok-actions #{Actions} --alarm-actions #{Actions}"
  end
end
