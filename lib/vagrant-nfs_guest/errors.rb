require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Error < Vagrant::Errors::VagrantError
      error_namespace("vagrant.config.nfs_guest.errors")
    end
  end
end
