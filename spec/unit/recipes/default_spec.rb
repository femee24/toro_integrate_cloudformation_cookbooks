#
# Cookbook Name:: toro_integrate_cloudformation_cookbooks
# Spec:: default
#
# Copyright (c) 2017 TORO Limited 2014-2017, All Rights Reserved.

require 'spec_helper'

describe 'toro_integrate_cloudformation_cookbooks::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
