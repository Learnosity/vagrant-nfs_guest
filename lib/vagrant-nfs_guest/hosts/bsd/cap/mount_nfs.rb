module VagrantPlugins
  module SyncedFolderNFSGuest
    module HostBSD
      module Cap
        class MountNFS

          def self.nfs_mount(environment, ui, id, ips, folders)
            folders.each do |name, opts|
              ips.each do |ip|
                ui.detail(I18n.t("vagrant.actions.vm.share_folders.mounting_entry",
                                 guestpath: opts[:guestpath],
                                 hostpath: opts[:hostpath]))

                mount_options = opts.fetch(:mount_options, ["noatime"])
                nfs_options = mount_options.empty? ? "" : "-o #{mount_options.join(',')}"

                mount_command = "mount -t nfs #{nfs_options} '#{ip}:#{opts[:guestpath]}' '#{opts[:hostpath]}'"
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
