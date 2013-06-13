#
# Cookbook Name:: equallogic
# Attributes:: default
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

# You need to set these in your host, role, cookbook, etc...
# default['equallogic']['iso'] = "http://example.com/path/to/equallogic-host-tools-1.2.0-2.iso"
default['equallogic']['iso'] = nil
default['equallogic']['wrap-iscsiadm'] = true
default['equallogic']['ifaces'] = ['eth0']
default['equallogic']['iscsid']['node.startup'] = "manual"
default['equallogic']['iscsid']['node.session.iscsi.FastAbort'] = "No"
default['equallogic']['iscsid']['node.session.cmds_max'] = 1024
default['equallogic']['iscsid']['node.session.queue_depth'] = 128
default['equallogic']['iscsid']['node.session.initial_login_retry_max'] = 12