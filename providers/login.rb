#
# Cookbook Name:: equallogic
# Provider:: login
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

action :execute do
  perform_login
end

private

def perform_login
  volume = new_resource.target.split(':').last
  onboot_option = new_resource.onboot ? "--login-at-boot" : ""
  login = execute "Logging in to #{new_resource.target}" do
    command "ehcmcli login --target #{new_resource.target} --portal #{new_resource.portal} #{onboot_option}"
    creates "/dev/mapper/eql-#{volume}"
    action :nothing
  end
  login.run_action(:run)

  if login.updated_by_last_action?
    new_resource.updated_by_last_action(true)
  end
end