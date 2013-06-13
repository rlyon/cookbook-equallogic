# equalogic cookbook

# Requirements
- Chef 11.2.0
- RHEL 6, Centos 6

# Usage
Installs and configures the Equalogic Host Integration Tools to set up multipathing support and configurations to connect equalogic iscsi volumes to servers.

Add 'recipe[equallogic]' to your run list and set the appropriate attributes.

# Attributes

These are required since the cookbook can't read your mind to find out where and what you are downloading:

* `default['equallogic']['iso']` - URL location of the installation ISO
* `default['equallogic']['ifaces']` - An array of the interfaces to be used for MPIO
* `default['equallogic']['iscsid']['node.startup']` - Log into the target at boot
* `default['equallogic']['iscsid']['node.session.iscsi.FastAbort']` - No
* `default['equallogic']['iscsid']['node.session.cmds_max']` - 1024
* `default['equallogic']['iscsid']['node.session.queue_depth']` - 128
* `default['equallogic']['iscsid']['node.session.initial_login_retry_max']` - 12

# Recipes

default.rb

* Add scripts to turn off GRO
* Configure iSCSI settings
* Configure eql.conf MPIO networks
* Enable iscsid service
* Enable ehcmd service
* Configure LVM filters
* Configure sysctl.conf to optimize settings for ARP flux, RP filter, network buffers, and the scheduler.

hitools.rb

* Grab the Equalogic equallogic ISO via HTTP from a website
* Mount and install the ISO if it has not been installed already
* Create a wrapper script around the iscsiadm script to solve a problem with way the newer version of iscisadm displays it's version.  The equallogic application expects the version to be formatted differently and will not start.

# Providers

## equallogic_login
Logs into an iscsi target using the ehcmcli command

### Attributes

* `target` - The iqn of the target.  Don't use the alias as the cookbook uses the tail end to check if the mapped device is present
* `portal` - The management interface of the equalogic array
* `onboot` - Ensure that the node.startup is configured to log in automatically at boot time

# Author
Author:: Rob Lyon (rlyon@uidaho.edu)
