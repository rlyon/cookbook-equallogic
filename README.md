# hittools cookbook

# Requirements
- Chef 11.2.0
- Centos 6.3

# Usage
Installs and configures the Equalogic Host Integration Tools to set up multipathing support and configurations to connect equalogic iscsi volumes to servers.

Add 'recipe[hittools]' to your run list and set the appropriate attributes.

# Attributes
These are required since the cookbook can't read your mind to find out where and what you are downloading:
- default['hittools']['url']: String - Url to the installation ISO
- default['hittools']['iso']: String - Name of the installation ISO
- default['hittolls']['ifaces']: Array - Interfaces to be used for MPIO
- default['hittools']['iscsid']['node.startup']: String (manual)
- default['hittools']['iscsid']['node.session.iscsi.FastAbort']: String (No)
- default['hittools']['iscsid']['node.session.cmds_max']: Fixnum(1024)
- default['hittools']['iscsid']['node.session.queue_depth']: Fixnum(128)
- default['hittools']['iscsid']['node.session.initial_login_retry_max']: Fixnum(12)

# Recipes
default.rb
- Grab the Equalogic Hittools ISO via HTTP from a website
- Mount and install the ISO if it has not been installed already
- Create a wrapper script around the iscsiadm script to solve a problem with way the newer version of iscisadm displays it's version.  The hittools application expects the version to be formatted differently and will not start.
- Add scripts to turn off GRO
- Configure iSCSI settings
- Configure eql.conf MPIO networks
- Enable iscsid service
- Enable ehcmd service
- Configure LVM filters
- Configure sysctl.conf to optimize settings for ARP flux, RP filter, network buffers, and the scheduler.

# Manual Intervention
The recipes do not currently support automatic discovery and login.  You will need to run the following commands:
- iscsiadm -m discovery -t st -p <group_management_ip>
- ehcmcli login --portal <group_management_ip> --target <volume_name> --login-at-boot

# Author
Author:: Rob Lyon (rlyon@uidaho.edu)
