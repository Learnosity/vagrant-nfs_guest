require Vagrant.source_root.join("plugins/guests/linux/cap/halt")

module VagrantPlugins
  module SyncedFolderNFSGuest
    module Cap
      module Linux
        class Halt
          def self.halt(machine)
            # unmount any host mounted NFS folders
            folders = machine.config.vm.synced_folders
            machine.env.host.unmount_nfs_folders(folders)

            VagrantPlugins::GuestLinux::Cap::Halt.halt(machine)
          end
        end
      end
    end
  end
end

