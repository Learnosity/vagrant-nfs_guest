require 'zlib'

module VagrantPlugins
  module SyncedFolderNFSGuest
    class SyncedFolder < Vagrant.plugin("2", :synced_folder)
      def usable?(machine, raise_error=false)
        # If the machine explicitly said NFS is not supported, then
        # it isn't supported.
        if !machine.config.nfs_guest.functional
          return false
        end
        return true if machine.env.host.capability(:nfs_installed)
        return false if !raise_error
        raise Vagrant::Errors::NFSNotSupported
      end

      def enable(machine, folders, nfsopts)
        verify_nfs_installation(machine) if machine.guest.capability?(:nfs_server_installed)

        machine_ip = nfsopts[:nfs_machine_ip]
        machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

        # Prepare the folder, this means setting up various options
        # and such on the folder itself.
        folders.each { |id, opts| prepare_folder(machine, opts) }

        # Only mount folders that have a guest path specified.
        mount_folders = {}
        folders.each do |id, opts|
          mount_folders[id] = opts.dup if opts[:guestpath]
        end

        machine.ui.info I18n.t("vagrant_nfs_guest.actions.vm.nfs.exporting")
        machine.guest.capability(
          :nfs_export, nfsopts[:nfs_host_ip], mount_folders)

        machine.ui.info I18n.t("vagrant_nfs_guest.actions.vm.nfs.mounting")
        machine.env.host.capability(
          :nfs_mount,
          machine.ui, machine.id, machine_ip, mount_folders
        )
      end

      def disable(machine, folders, _opts)
        if machine.env.host.capability(:nfs_unmount)
          machine_ip = nfsopts[:nfs_machine_ip]
          machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

          # Only mount folders that have a guest path specified.
          mount_folders = {}
          folders.each do |id, opts|
            mount_folders[id] = opts.dup if opts[:guestpath]
          end

          machine.env.host.capability(
            :nfs_unmount,
            machine.ui, machine.id, machine_ip, mount_folders
          )
        end

        # Remove the shared folders from the VM metadata
        names = folders.map { |id, _data| os_friendly_id(id) }
        driver(machine).unshare_folders(names)
      end

      protected

      def prepare_folder(machine, opts)
        opts[:map_uid] = prepare_permission(machine, :uid, opts)
        opts[:map_gid] = prepare_permission(machine, :gid, opts)
        opts[:nfs_udp] = true if !opts.has_key?(:nfs_udp)
        opts[:nfs_version] ||= 3

        # We use a CRC32 to generate a 32-bit checksum so that the
        # fsid is compatible with both old and new kernels.
        opts[:uuid] = Zlib.crc32(opts[:hostpath]).to_s
      end

      # Prepares the UID/GID settings for a single folder.
      def prepare_permission(machine, perm, opts)
        key = "map_#{perm}".to_sym
        return nil if opts.has_key?(key) && opts[key].nil?

        # The options on the hash get priority, then the default
        # values
        value = opts.has_key?(key) ? opts[key] : machine.config.nfs.send(key)
        return value if value != :auto

        # Get UID/GID from guests user if we've made it this far
        # (value == :auto)
        return machine.guest.capability("read_#{perm}".to_sym)
      end

      private

      def verify_nfs_installation(machine)
        if !machine.guest.capability(:nfs_server_installed)
          raise Errors::NFSServerNotInstalledInGuest unless machine.guest.capability?(:nfs_server_install)

          machine.ui.info I18n.t("vagrant_nfs_guest.guests.linux.nfs_server_installing")
          machine.guest.capability(:nfs_server_install)
        end
      end
    end
  end
end

