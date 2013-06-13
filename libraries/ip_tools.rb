require 'ipaddr'
class Chef
  module Equallogic
    module IpTools
      def ip_start_and_netmask(iface)
        retval = []

        ips = node['network']['interfaces'][iface]['addresses'].select do |k,v|
          v['family'] == "inet"
        end

        ips.each do |k,v|
          ipa = IPAddr.new("#{k}/#{v['netmask']}")
          ipstart = ipa.to_range.first.to_s
          retval << "#{ipstart} - #{v['netmask']}"
        end
        
        retval
      end
    end
  end
end