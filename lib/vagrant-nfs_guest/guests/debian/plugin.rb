require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "Debian guest"
      description "Debian guest support."

      guest_capability(:debian, :nfs_test_command) do
        require_relative "cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end

      guest_capability(:debian, "nfs_server_installed") do
        require_relative "cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end

      guest_capability(:debian, :nfs_server_install) do
        require_relative "cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end
    end
  end
end
