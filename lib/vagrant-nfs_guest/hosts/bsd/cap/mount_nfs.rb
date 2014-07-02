require "log4r"

module VagrantPlugins
  module HostBSD
    module Cap
      class MountNFS

        def self.nfs_mount(environment, ui, id, ips, folders)
          folders.each do |name, opts|
            ips.each do |ip|
              ui.detail(I18n.t("vagrant.actions.vm.share_folders.mounting_entry",
                               guestpath: opts[:guestpath],
                               hostpath: opts[:hostpath]))

              system("mkdir -p #{opts[:hostpath]}")
              mount_command = "mount -t nfs -o noatime '#{ip}:#{opts[:guestpath]}' '#{opts[:hostpath]}'"
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
