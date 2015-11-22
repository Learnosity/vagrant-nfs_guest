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

      synced_folder(:nfs_guest, 4) do
        require_relative "synced_folder"
        SyncedFolder
      end

      # ==== GUEST - BASE LINUX ====
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

      guest_capability(:linux, :nfs_test_command) do
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

      # ==== GUEST - DEBIAN ====
      guest_capability(:debian, :nfs_test_command) do
        require_relative "guests/debian/cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end

      guest_capability(:debian, "nfs_server_installed") do
        require_relative "guests/debian/cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end

      guest_capability(:debian, :nfs_server_install) do
        require_relative "guests/debian/cap/nfs_server"
        GuestDebian::Cap::NFSServer
      end

      # ==== GUEST - UBUNTU ====
      guest_capability(:ubuntu, "nfs_server_installed") do
        require_relative "guests/ubuntu/cap/nfs_server"
        GuestUbuntu::Cap::NFSServer
      end

      guest_capability(:ubuntu, :nfs_server_install) do
        require_relative "guests/ubuntu/cap/nfs_server"
        GuestUbuntu::Cap::NFSServer
      end

      # ==== GUEST - REDHAT ====
      guest_capability(:redhat, "nfs_server_installed") do
        require_relative "guests/redhat/cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_server_install) do
        require_relative "guests/redhat/cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_check_command) do
        require_relative "guests/redhat/cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      guest_capability(:redhat, :nfs_start_command) do
        require_relative "guests/redhat/cap/nfs_server"
        GuestRedHat::Cap::NFSServer
      end

      # ==== HOST - BSD ====
      host_capability("bsd", "nfs_mount") do
        require_relative "hosts/bsd/cap/mount_nfs"
        HostBSD::Cap::MountNFS
      end

      host_capability("bsd", "nfs_unmount") do
        require_relative "hosts/bsd/cap/unmount_nfs"
        HostBSD::Cap::UnmountNFS
      end

      # ==== HOST - LINUX ====
      host_capability(:linux, "nfs_mount") do
        require_relative "hosts/linux/cap/mount_nfs"
        HostLinux::Cap::MountNFS
      end

      host_capability(:linux, "nfs_unmount") do
        require_relative "hosts/linux/cap/unmount_nfs"
        HostLinux::Cap::UnmountNFS
      end

      # ==== ACTION HOOKS ====
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
