module VagrantPlugins
  module SyncedFolderNFSGuest
    module ProviderParallels
      module Cap

        def self.nfs_settings(machine)
          host_ip  = machine.provider.driver.read_shared_interface[:ip]
          machine_ip = machine.provider.driver.read_guest_ip

          raise Vagrant::Errors::NFSNoHostonlyNetwork if !host_ip || !machine_ip

          return host_ip, machine_ip
        end
      end
    end
  end
end
