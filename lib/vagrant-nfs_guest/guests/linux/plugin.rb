require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "Linux guest."
      description "Linux guest support."

      guest_capability(:linux, :nfs_export) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :nfs_apply_command) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :nfs_check_command) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :nfs_start_command) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :nfs_test_command) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :nfs_exports_template) do
        require_relative "cap/nfs_server"
        GuestLinux::Cap::NFSServer
      end

      guest_capability(:linux, :read_uid) do
        require_relative "cap/read_user_ids"
        GuestLinux::Cap::ReadUserIDs
      end

      guest_capability(:linux, :read_gid) do
        require_relative "cap/read_user_ids"
        GuestLinux::Cap::ReadUserIDs
      end
    end
  end
end
