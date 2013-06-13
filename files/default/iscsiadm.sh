#!/bin/sh
#
# ISCSIadm on CentOS 6 outputs the version in a way that the hitools cannot understand
# it so wrap ISCSIadm so it prints out the version that is being expected.
if [ "$1" == "--version" ] ; then
  # Go old school version-revision
  version=`rpm -q iscsi-initiator-utils --qf "%{VERSION}" | cut -d'.' -f2-3`
  revision=`rpm -q iscsi-initiator-utils --qf "%{VERSION}.%{RELEASE}" | cut -d'.' -f4-`
  echo "iscsiadm version $version-$revision"
  exit 0
fi

iscsiadm.bin $@