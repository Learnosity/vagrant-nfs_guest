module VagrantPlugins
  module HostBSD
    class Host < Vagrant.plugin("2", :host)
      def mount_nfs_folders(id, ips, folders)
        @logger.debug "Mounting NFS mounts..."
        folders.each do |name, opts|
          @logger.info opts
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
        @logger.debug "Unmounting NFS mounts..."
        folders.each do |name, opts|
          if opts[:type] == :nfs_guest
            expanded_host_path = `printf #{opts[:hostpath]}`
            umount_msg = `umount '#{expanded_host_path}' 2>&1`
            @ui.info umount_msg
            if $?.exitstatus != 0
              if not umount_msg.include? 'not currently mounted'
                @ui.info "NFS mounts still in use!"
                exit(1)
              end
            end
          end
        end
      end
    end
  end
end

