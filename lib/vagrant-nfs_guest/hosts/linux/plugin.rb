require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "Linux host"
      description "Linux host support."

      host_capability(:linux, "nfs_mount") do
        require_relative "cap/mount_nfs"
        HostLinux::Cap::MountNFS
      end

      host_capability(:linux, "nfs_unmount") do
        require_relative "cap/unmount_nfs"
        HostLinux::Cap::UnmountNFS
      end
    end
  end
end
