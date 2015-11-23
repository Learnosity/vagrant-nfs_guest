require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "Red Hat Enterprise Linux guest"
      description "Red Hat Enterprise Linux guest support."

      guest_capability(:redhat, "nfs_server_installed") do
        require_relative "cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_server_install) do
        require_relative "cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_check_command) do
        require_relative "cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_start_command) do
        require_relative "cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_setup_firewall) do
        require_relative "cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end
    end
  end
end
