module VagrantPlugins
  module SyncedFolderNFSGuest
    module ProviderDocker
      module Cap

        def self.nfs_settings(machine)
          provider = machine.provider

          host_ip    = provider.driver.docker_bridge_ip
          machine_ip = provider.ssh_info[:host]

          raise Vagrant::Errors::NFSNoHostonlyNetwork if !host_ip || !machine_ip

          return host_ip, machine_ip
        end
      end
    end
  end
end
