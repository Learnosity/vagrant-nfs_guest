module VagrantPlugins
  module SyncedFolderNFSGuest
    class Plugin < Vagrant.plugin("2")
      name "vagrant-nfs_guest"
      description <<-DESC
      Adds support for guest nfs exporting of synced folders
      DESC

      config(:nfs_guest) do
        require File.expand_path("../config", __FILE__)
        Config
      end

      synced_folder(:nfs_guest, 4) do
        require File.expand_path("../synced_folder", __FILE__)
        SyncedFolder
      end

      guest_capability(:linux, :export_nfs_folders) do
        require File.expand_path("../cap/linux/export_nfs_folders", __FILE__)
        Cap::Linux::ExportNFS
      end

      guest_capability(:linux, :export_nfs_capable) do
        require File.expand_path("../cap/linux/export_nfs_folders", __FILE__)
        Cap::Linux::ExportNFS
      end

      guest_capability(:linux, :read_uid) do
        require File.expand_path("../cap/linux/read_user_ids", __FILE__)
        Cap::Linux::ReadUserIDs
      end

      guest_capability(:linux, :read_gid) do
        require File.expand_path("../cap/linux/read_user_ids", __FILE__)
        Cap::Linux::ReadUserIDs
      end

      require File.expand_path("../action/prepare_nfs_guest_settings", __FILE__)
      action_hook(:nfs_guest, :machine_action_up) do |hook|
        hook.before(VagrantPlugins::ProviderVirtualBox::Action::PrepareNFSSettings,
                   Action::PrepareNFSGuestSettings)
      end
    end
  end
end
