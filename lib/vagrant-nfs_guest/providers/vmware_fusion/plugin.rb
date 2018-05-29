require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "vmware_fusion-provider"
      description "vagrant-vmware_fusion provider"

      provider_capability(:vmware_fusion, :nfs_settings) do
        require_relative "cap/nfs_settings"
        ProviderVMwareFusion::Cap
      end
    end
  end
end
