module VagrantPlugins
  module SyncedFolderNFSGuest
    module ProviderVMwareFusion
      module Cap
        def self.read_host_ip
          # In practice, we need the host's IP on the vmnet device this VM uses.
          # It seems a bit tricky to get the right one, so let's allow all.
          return `for N in $(ifconfig | awk -F: '/vmnet/ { print $1; }'); do ifconfig $N | awk '/inet / { print $2; }'; done`.split("\n")
        end

        def self.nfs_settings(machine)
          host_ip = self.read_host_ip
          machine_ip = machine.provider.driver.read_ip
          return host_ip, machine_ip
        end
      end
    end
  end
end
