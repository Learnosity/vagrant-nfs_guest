module VagrantPlugins
  module SyncedFolderNFSGuest
    module GuestRedHat
      module Cap
        class NFSServer
          def self.nfs_server_install(machine)
            machine.communicate.sudo("yum -y install nfs-utils nfs-utils-lib")
          end

          def self.nfs_server_installed(machine)
            machine.communicate.test("test -e /etc/init.d/nfs")
          end
        end
      end
    end
  end
end
