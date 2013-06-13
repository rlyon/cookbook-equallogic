# equalogic cookbook

Installs and configures the Equalogic Host Integration Tools to set up multipathing support and configurations to connect equalogic iscsi volumes to servers.

# Requirements
- Chef 11.2.0
- RHEL 6, Centos 6

# Usage

Add `recipe[equallogic]` to your run list and set the appropriate attributes for configuration and addition of the login provider.  To automatically install the host integration tools, you will need to provide a url to the iso as it is not provided.  The best thing to do is download the iso from Dell's website and serve via http it internally.

# Attributes

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
