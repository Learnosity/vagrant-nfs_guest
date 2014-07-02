require "vagrant"

module VagrantPlugins
  module HostBSD
    class Plugin < Vagrant.plugin("2")

      host_capability("bsd", "nfs_mount") do
        require_relative "cap/mount_nfs"
        Cap::MountNFS
      end

      host_capability("bsd", "nfs_unmount") do
        require_relative "cap/unmount_nfs"
        Cap::UnmountNFS
      end
    end
  end
end
