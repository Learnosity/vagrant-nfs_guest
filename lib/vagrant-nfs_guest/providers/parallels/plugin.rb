require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "vagrant-parallels"
      description "Parallels provider"

      provider_capability(:parallels, :nfs_settings) do
        require_relative "cap/nfs_settings"
        ProviderParallels::Cap
      end
    end
  end
end
