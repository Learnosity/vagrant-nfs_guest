module VagrantPlugins
  module SyncedFolderNFSGuest
    module GuestUbuntu
      module Cap
        class NFSServer
          def self.nfs_server_install(machine)
            machine.communicate.sudo("apt-get update")
            machine.communicate.sudo("apt-get -y install nfs-kernel-server")
          end

          def self.nfs_server_installed(machine)
            machine.communicate.test("test -e /etc/init.d/nfs-kernel-server")
          end
        end
      end
    end
  end
end
