begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant AWS plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant AWS plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module SyncedFolderNFSGuest
    # This plugin implements Guest Exported NFS folders.
    #
    class Plugin < Vagrant.plugin("2")
      name "vagrant-nfs_guest"
      description <<-DESC
      The NFS Guest synced folders plugin enables you to use NFS exports from
      the Guest as a synced folder implementation.
      DESC

      config(:nfs_guest) do
        require_relative "config"
        Config
      end

      synced_folder(:nfs_guest, 4) do
        require_relative "synced_folder"
        SyncedFolder
      end

      guest_capability(:linux, :nfs_export) do
        require_relative "guests/linux/cap/nfs_export"
        GuestLinux::Cap::NFSExport
      end

      guest_capability(:linux, :nfs_apply_command) do
        require_relative "guests/linux/cap/nfs_export"
        GuestLinux::Cap::NFSExport
      end

      guest_capability(:linux, :nfs_check_command) do
        require_relative "guests/linux/cap/nfs_export"
        GuestLinux::Cap::NFSExport
      end

      guest_capability(:linux, :nfs_start_command) do
        require_relative "guests/linux/cap/nfs_export"
        GuestLinux::Cap::NFSExport
      end

      guest_capability(:linux, :nfs_exports_template) do
        require_relative "guests/linux/cap/nfs_export"
        GuestLinux::Cap::NFSExport
      end

      guest_capability(:linux, :read_uid) do
        require_relative "guests/linux/cap/read_user_ids"
        GuestLinux::Cap::ReadUserIDs
      end

      guest_capability(:linux, :read_gid) do
        require_relative "guests/linux/cap/read_user_ids"
        GuestLinux::Cap::ReadUserIDs
      end

      action_hook(:nfs_guest, :machine_action_up) do |hook|
        require_relative "action/prepare_nfs_guest_settings"
        hook.after(
          VagrantPlugins::ProviderVirtualBox::Action::Boot,
          Action::PrepareNFSGuestSettings
        )
      end

      action_hook(:nfs_guest, :machine_action_reload) do |hook|
        require_relative "action/prepare_nfs_guest_settings"
        hook.before(
          VagrantPlugins::ProviderVirtualBox::Action::PrepareNFSSettings,
          Action::PrepareNFSGuestSettings
        )
      end

      action_hook(:nfs_guest, :machine_action_resume) do |hook|
        require_relative "action/mount_nfs"
        require_relative "action/prepare_nfs_guest_settings"
        hook.after(
          VagrantPlugins::ProviderVirtualBox::Action::WaitForCommunicator,
          Action::PrepareNFSGuestSettings
        )
        hook.after(
          Action::PrepareNFSGuestSettings,
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
        hook.before(
          Vagrant::Action::Builtin::GracefulHalt,
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

      action_hook(:nfs_guest, :machine_action_destroy) do |hook|
        require_relative "action/unmount_nfs"
        hook.after(
          Vagrant::Action::Builtin::DestroyConfirm,
          Action::UnmountNFS
        )
      end

      action_hook(:nfs_guest, :machine_action_suspend) do |hook|
        require_relative "action/unmount_nfs"
        hook.before(
          VagrantPlugins::ProviderVirtualBox::Action::Suspend,
          Action::UnmountNFS
        )
      end
    end
  end
end
