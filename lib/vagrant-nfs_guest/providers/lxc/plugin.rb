require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "lxc-provider"
      description "vagrant-lxc provider"

      provider_capability(:lxc, :nfs_settings) do
        require_relative "cap/nfs_settings"
        ProviderLxc::Cap
      end
    end
  end
end
