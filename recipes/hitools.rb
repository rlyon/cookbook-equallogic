#
# Cookbook Name:: equallogic
# Recipe:: hitools
#
# Copyright 2013, Rob Lyon
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

# Make sure to get the ISO from a downloadable source. I'm unsure of the distribution
# rights so I don't want to package the ISO with the recipe (plus it's really big).
# You'll probably want to serve it up internally
Chef::Application.fatal!(
  "You must tell me where to get the iso to install the host integration tools", 42
) if node['equallogic']['iso'].nil?

directory "/deploy" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# any way to not get this if we are already installed?
remote_file "/deploy/equallogic-host-tools.iso" do
  source "#{node['equallogic']['iso']}"
  action :create_if_missing
end

# Ensure that /mnt/iso is unmounted so the directory check on create does not
# fail.  This also has the added benefit of unmounting the iso once the install is
# complete
execute "umount /mnt/iso" do
  command "umount /mnt/iso"
  only_if "grep '/mnt/iso' /proc/mounts && [ -d /mnt/iso ]"
end

# Mount the iso for the install
directory "/mnt/iso" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# Install and import the EQL public signing key
# cookbook_file "/deploy/RPM-GPG-KEY-DELLEQL" do
#   source "#{node['equallogic']['iso']}.pgp"
#   owner "root"
#   group "root"
#   mode 0644
# end

# execute "import gpg key for dell equallogic-host-tools" do
#   command "rpm --import /deploy/RPM-GPG-KEY-DELLEQL"
#   not_if "rpm -qa --info gpg-pubkey* | grep 'Dell EqualLogic'"
# end

# Only mount it if the tools are not installed
execute "mount the hit tools iso if not installed" do
  command "mount -o loop /deploy/equallogic-host-tools.iso /mnt/iso"
  not_if "rpm -qa | grep equallogic-host-tools 1>/dev/null"
end

# Run the installer script
execute "install" do
  command "sh /mnt/iso/install --nogpgcheck --accepted-EULA --noninteractive"
  not_if "rpm -qa | grep equallogic-host-tools 1>/dev/null"
end

# Wrap the iscsiadm to display the version in a format that the eql tools are
# expecting.
if node['equallogic']['wrap-iscsiadm']
  execute "move iscsiadm to iscsiadm.bin" do
    command "mv /sbin/iscsiadm /sbin/iscsiadm.bin"
    only_if "file /sbin/iscsiadm | grep 'ELF'"
  end

  cookbook_file "/sbin/iscsiadm" do
    source "iscsiadm.sh"
    owner "root"
    group "root"
    mode 0755
  end
end