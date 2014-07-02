require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    module Errors

      class Error < Vagrant::Errors::VagrantError
        error_namespace("vagrant_nfs_guest.errors")
      end

      class GuestNFSError < Error
        error_key(:nfs_start_failed)
        error_key(:nfs_apply_failed)
        error_key(:nfs_update_exports_failed)
      end

    end
  end
end
