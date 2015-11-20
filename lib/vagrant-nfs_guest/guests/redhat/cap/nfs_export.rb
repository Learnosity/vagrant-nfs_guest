require "vagrant/util/retryable"

module VagrantPlugins
  module SyncedFolderNFSGuest
    module GuestRedHat
      module Cap
        class NFSExport
          extend Vagrant::Util::Retryable

          def self.nfs_check_command(env)
            "/etc/init.d/nfs status"
          end

          def self.nfs_start_command(env)
            "/etc/init.d/nfs start"
          end

        end
      end
    end
  end
end
