require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    module Errors

      class Error < Vagrant::Errors::VagrantError
        error_namespace("vagrant_nfs_guest.errors")
      end

      class GuestNFSError < Error
        error_key(:nfs_server_missing)
        error_key(:nfs_start_failed)
        error_key(:nfs_apply_failed)
        error_key(:nfs_update_exports_failed)
        error_key(:nfs_guest_clean)
        error_key(:nfs_create_mounts_failed)
      end

      class NFSServerMissing < Error
        error_key(:nfs_server_missing)
      end

      class NFSServerNotInstalledInGuest < Error
        error_key(:nfs_server_not_installed)
      end

      class ProviderNFSSettingsCapMissing < Error
        error_key(:provider_missing_nfs_setting_cap)
      end
    end
  end
end
