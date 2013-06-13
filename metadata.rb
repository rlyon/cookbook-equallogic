name             "equallogic"
maintainer       "Rob Lyon"
maintainer_email "rlyon@uidaho.edu"
license          "Apache 2.0"
description      "Installs/Configures the equallogic host integration tools and manages target login"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "sysctl", "= 0.3.1"

%w{ redhat centos }.each do |os|
  supports os
end
