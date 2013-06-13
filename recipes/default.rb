#
# Cookbook Name:: equallogic
# Recipe:: default
#
# Copyright 2013, Rob Lyon (rlyon@uidaho.edu)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class Chef::Recipe
  include Chef::Equallogic::IpTools
end

# Tuning GRO
directory "/etc/equallogic/eqltune.d" do
  owner "root"
  group "root"
  mode 0755
  action :create
  notifies :reload, 'service[ehcmd]', :delayed
end

nets = Array.new
node['equallogic']['ifaces'].each do |iface|
  template "/etc/equallogic/eqltune.d/gro.#{iface}" do
    source "gro.iface.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :iface => iface
    })
    notifies :reload, 'service[ehcmd]', :delayed
  end
  nets += ip_start_and_netmask(iface)
end

template "/etc/equallogic/eql.conf" do
  source "eql.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :networks => nets
  })
  notifies :reload, 'service[ehcmd]', :delayed
end

template "/etc/iscsi/iscsid.conf" do
  source "iscsid.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[iscsid]'
  notifies :reload, 'service[ehcmd]', :delayed
end

service 'iscsid' do
  supports :status => true, :restart => true, :reload => false
  action [ :enable, :start ]
end

service 'ehcmd' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Make sure that LVM is filtering ignored devices
template "/etc/lvm/lvm.conf" do
  source "lvm.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

# Set up sysctl
include_recipe "sysctl"
node['equallogic']['ifaces'].each do |iface|
  # Change this to LWRP once they get it fixed.
  node.default['sysctl']['params']['net']['ipv4']['conf'][iface]['arp_ignore'] = 1
  node.default['sysctl']['params']['net']['ipv4']['conf'][iface]['arp_announce'] = 2
  node.default['sysctl']['params']['net']['ipv4']['conf'][iface]['rp_filter'] = 2
end

