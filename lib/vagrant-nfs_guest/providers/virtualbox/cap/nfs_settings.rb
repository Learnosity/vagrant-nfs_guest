require "vagrant/util/retryable"

module VagrantPlugins
  module SyncedFolderNFSGuest
    module ProviderVirtualBox
      module Cap
        extend Vagrant::Util::Retryable

        def self.nfs_settings(machine)
          adapter, host_ip = self.find_host_only_adapter(machine)
          machine_ip       = self.read_static_machine_ips(machine) || self.read_dynamic_machine_ip(machine, adapter)

          raise Vagrant::Errors::NFSNoHostonlyNetwork if !host_ip || !machine_ip

          return host_ip, machine_ip
        end

        # Finds first host only network adapter and returns its adapter number
        # and IP address
        #
        # @return [Integer, String] adapter number, ip address of found host-only adapter
        def self.find_host_only_adapter(machine)
          machine.provider.driver.read_network_interfaces.each do |adapter, opts|
            if opts[:type] == :hostonly
              machine.provider.driver.read_host_only_interfaces.each do |interface|
                if interface[:name] == opts[:hostonly]
                  return adapter, interface[:ip]
                end
              end
            end
          end

          nil
        end

        # Returns the IP address(es) of the guest by looking for static IPs
        # given to host only adapters in the Vagrantfile
        #
        # @return [Array]<String> Configured static IPs
        def self.read_static_machine_ips(machine)
          ips = []
          machine.config.vm.networks.each do |type, options|
            if type == :private_network && options[:type] != :dhcp && options[:ip].is_a?(String)
              ips << options[:ip]
            end
          end

          if ips.empty?
            return nil
          end

          ips
        end

        # Returns the IP address of the guest by looking at vbox guest property
        # for the appropriate guest adapter.
        #
        # For DHCP interfaces, the guest property will not be present until the
        # guest completes
        #
        # @param [Integer] adapter number to read IP for
        # @return [String] ip address of adapter
        def self.read_dynamic_machine_ip(machine, adapter)
          return nil unless adapter

          # vbox guest properties are 0-indexed, while showvminfo network
          # interfaces are 1-indexed. go figure.
          guestproperty_adapter = adapter - 1

          # we need to wait for the guest's IP to show up as a guest property.
          # retry thresholds are relatively high since we might need to wait
          # for DHCP, but even static IPs can take a second or two to appear.
          retryable(retry_options.merge(on: Vagrant::Errors::VirtualBoxGuestPropertyNotFound)) do
            machine.provider.driver.read_guest_ip(guestproperty_adapter)
          end
        rescue Vagrant::Errors::VirtualBoxGuestPropertyNotFound
          # this error is more specific with a better error message directing
          # the user towards the fact that it's probably a reportable bug
          raise Vagrant::Errors::NFSNoGuestIP
        end

        # Separating these out so we can stub out the sleep in tests
        def self.retry_options
          {tries: 15, sleep: 1}
        end
      end
    end
  end
end
