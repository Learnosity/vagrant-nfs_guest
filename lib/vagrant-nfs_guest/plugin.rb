begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant NFS Guest plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant NFS Guest plugin is only compatible with Vagrant 1.2+"
end

require_relative "guests/debian/plugin"
require_relative "guests/linux/plugin"
require_relative "guests/redhat/plugin"
require_relative "guests/ubuntu/plugin"
require_relative "hosts/bsd/plugin"
require_relative "hosts/linux/plugin"
require_relative "providers/virtualbox/plugin"
require_relative "providers/parallels/plugin"
require_relative "providers/docker/plugin"

module VagrantPlugins
  module SyncedFolderNFSGuest
    # This plugin implements Guest Exported NFS folders.
    #
    class Plugin < Vagrant.plugin("2")
      name "vagrant-nfs_guest"
      description <<-DESC
      The Vagrant NFS Guest synced folders plugin enables you to use NFS exports from
      the Guest as a synced folder implementation. This allows the guest to utilise
      inotify (eg. file watchers) and other filesystem related functions that don't
      work across NFS from the host.
      DESC

      config(:nfs_guest) do
        require_relative "config"
        Config
      end

      synced_folder(:nfs_guest, 5) do
        require_relative "synced_folder"
        SyncedFolder
      end

      action_hook(:nfs_guest, :machine_action_up) do |hook|
        require_relative "action/mount_nfs"
        hook.before(
          Vagrant::Action::Builtin::WaitForCommunicator,
          Action::MountNFS
        )
        hook.before(
          Vagrant::Action::Builtin::SyncedFolders,
          Action::MountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_suspend) do |hook|
        require_relative "action/unmount_nfs"
        hook.prepend(Action::UnmountNFS)
      end

      action_hook(:nfs_guest, :machine_action_resume) do |hook|
        require_relative "action/mount_nfs"
        hook.after(
          Vagrant::Action::Builtin::WaitForCommunicator,
          Action::MountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_halt) do |hook|
        require_relative "action/unmount_nfs"
        hook.before(
          Vagrant::Action::Builtin::GracefulHalt,
          Action::UnmountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_reload) do |hook|
        require_relative "action/unmount_nfs"
        require_relative "action/mount_nfs"
        hook.before(
          Vagrant::Action::Builtin::GracefulHalt,
          Action::UnmountNFS
        )
        hook.before(
          Vagrant::Action::Builtin::SyncedFolders,
          Action::MountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_destroy) do |hook|
        require_relative "action/unmount_nfs"
        hook.after(
          Vagrant::Action::Builtin::DestroyConfirm,
          Action::UnmountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_package) do |hook|
        require_relative "action/unmount_nfs"
        hook.before(
          Vagrant::Action::Builtin::GracefulHalt,
          Action::UnmountNFS
        )
      end
    end
  end
end
