require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "Ubuntu guest"
      description "Ubuntu guest support."

      guest_capability(:ubuntu, "nfs_server_installed") do
        require_relative "cap/nfs_server"
        GuestUbuntu::Cap::NFSServer
      end

      guest_capability(:ubuntu, :nfs_server_install) do
        require_relative "cap/nfs_server"
        GuestUbuntu::Cap::NFSServer
      end
    end
  end
end
