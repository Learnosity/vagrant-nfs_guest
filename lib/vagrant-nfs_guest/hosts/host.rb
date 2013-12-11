module Vagrant
  module Plugin
    module V2
      class Host
        # Mounts the given hash of folders via the guests NFS export
        #
        # @param [String] id A unique ID that is guaranteed to be unique to
        #   match these sets of folders.
        # @param [Array<String>] ip IPs of the guest machine.
        # @param [Hash] folders Shared folders to sync.
        def mount_nfs_folders(id, ips, folders)
        end

        # Unmounts the given hash of folders
        #
        # @param [Hash] folders Shared folders to sync.
        def unmount_nfs_folders(folders)
        end
      end
    end
  end
end

