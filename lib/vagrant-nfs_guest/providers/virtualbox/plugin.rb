require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "VirtualBox provider"
      description "VirtualBox provider"

      provider_capability(:virtualbox, :nfs_settings) do
        require_relative "cap/nfs_settings"
        ProviderVirtualBox::Cap
      end
    end
  end
end
