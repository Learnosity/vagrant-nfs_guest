module VagrantPlugins
  module HostBSD
    class Host < Vagrant.plugin("2", :host)
      def mount_nfs_folders(id, ips, folders)
        folders.each do |name, opts|
          ips.each do |ip|
            system("mkdir -p #{opts[:hostpath]}")
            mount_command = "mount -t nfs -o noatime '#{ip}:#{opts[:guestpath]}' '#{opts[:hostpath]}'"
            if system(mount_command)
              break
            end
          end
        end
      end

      def unmount_nfs_folders(folders)
        folders.each do |name, opts|
          if opts[:type] == :nfs_guest
            expanded_host_path = `printf #{opts[:hostpath]}`
            system("umount '#{expanded_host_path}'")
          end
        end
      end
    end
  end
end

