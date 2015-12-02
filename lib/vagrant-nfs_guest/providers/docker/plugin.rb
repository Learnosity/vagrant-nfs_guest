require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "docker-provider"
      description "Docker provider"

      provider_capability(:docker, :nfs_settings) do
        require_relative "cap/nfs_settings"
        ProviderDocker::Cap
      end
    end
  end
end
