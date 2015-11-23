require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "BSD host"
      description "BSD host support."

      host_capability("bsd", "nfs_mount") do
        require_relative "cap/mount_nfs"
        HostBSD::Cap::MountNFS
      end

      host_capability("bsd", "nfs_unmount") do
        require_relative "cap/unmount_nfs"
        HostBSD::Cap::UnmountNFS
      end
    end
  end
end
