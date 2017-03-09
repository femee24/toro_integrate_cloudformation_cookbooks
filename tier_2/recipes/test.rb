#
# Cookbook Name:: tier_2
# Recipe:: default
#
# Copyright (c) 2017 TORO Limited, All Rights Reserved.

override = data_bag('properties')

template '/tmp/override.properties' do
        source 'override.properties.erb'
        variables(
            http: override['http']
        )
end
