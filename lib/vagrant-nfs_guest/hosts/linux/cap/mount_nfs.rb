module VagrantPlugins
  module SyncedFolderNFSGuest
    module HostLinux
      module Cap
        class MountNFS

          def self.nfs_mount(environment, ui, id, ips, folders)
            folders.each do |name, opts|
              if opts[:type] != :nfs
                next
              end

              ips.each do |ip|
                ui.detail(I18n.t("vagrant.actions.vm.share_folders.mounting_entry",
                                 guestpath: opts[:guestpath],
                                 hostpath: opts[:hostpath]))

                system("mkdir -p #{opts[:hostpath]}")
                mount_command = "sudo mount -t nfs -o noatime '#{ip}:#{opts[:guestpath]}' '#{opts[:hostpath]}'"
                if system(mount_command)
                  break
                end
              end
            end
          end

        end
      end
    end
  end
end
