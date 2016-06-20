require 'zlib'

module VagrantPlugins
  module SyncedFolderNFSGuest
    class SyncedFolder < Vagrant.plugin("2", :synced_folder)

      def initialize(*args)
        super

        @logger = Log4r::Logger.new("vagrant::synced_folders::nfs_guest")
      end

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
        if !machine.provider.capability?(:nfs_settings)
          raise Errors::ProviderNFSSettingsCapMissing
        end

        # I've abstracted this out to a plugin provided capability per
        # provider as it's impossible to resume a VM because the
        # PrepareNFSSettings action NEVER is trigger on a resume because
        # the host is exporting so therefore it's assumed to always be there.
        # Easier to maintain and add new providers this way.
        host_ip, machine_ip = machine.provider.capability(:nfs_settings)
        machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

        raise Vagrant::Errors::NFSNoHostonlyNetwork if !host_ip || !machine_ip

        if machine.config.nfs_guest.verify_installed
          if machine.guest.capability?(:nfs_server_installed)
            installed = machine.guest.capability(:nfs_server_installed)
            if !installed
              can_install = machine.guest.capability?(:nfs_server_install)
              raise Errors::NFSServerNotInstalledInGuest if !can_install
              machine.ui.info I18n.t("vagrant_nfs_guest.guests.linux.nfs_server_installing")
              machine.guest.capability(:nfs_server_install)
            end
          end
        end

        # Prepare the folder, this means setting up various options
        # and such on the folder itself.
        folders.each { |id, opts| prepare_folder(machine, opts) }

        # Only mount folders that have a guest path specified.
        mount_folders = {}
        folders.each do |id, opts|
          mount_folders[id] = opts.dup if opts[:guestpath]
        end

        machine.ui.info I18n.t("vagrant_nfs_guest.actions.vm.nfs.exporting")
        machine.guest.capability(:nfs_export, host_ip, mount_folders)
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
    end
  end
end

