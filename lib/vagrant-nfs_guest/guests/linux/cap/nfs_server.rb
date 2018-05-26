require "vagrant/util/retryable"

module VagrantPlugins
  module SyncedFolderNFSGuest
    module GuestLinux
      module Cap
        class NFSServer
          extend Vagrant::Util::Retryable

          def self.nfs_apply_command(machine)
            machine.communicate.sudo(
              "exportfs -r",
              error_class: Errors::GuestNFSError,
              error_key: :nfs_apply_failed
            )
          end

          def self.nfs_start_command(machine)
            machine.communicate.sudo(
              "/etc/init.d/nfs-kernel-server start",
              error_class: Errors::GuestNFSError,
              error_key: :nfs_start_failed
            )
          end

          def self.nfs_check_command(machine)
            machine.communicate.test(
              "/etc/init.d/nfs-kernel-server status"
            )
          end

          def self.nfs_test_command(machine)
            machine.communicate.test(
              "which exportfs"
            )
          end

          def self.nfs_exports_template(machine)
            VagrantPlugins::SyncedFolderNFSGuest.source_root.join(
              "templates/nfs_guest/guest_export_linux")
          end

          def self.nfs_capable?(machine)
            machine.guest.capability(:nfs_test_command)
          end

          def self.nfs_apply_changes!(machine)
            machine.guest.capability(:nfs_apply_command)
          end

          def self.nfs_start!(machine)
            machine.guest.capability(:nfs_start_command)
          end

          def self.nfs_running?(machine)
            machine.guest.capability(:nfs_check_command)
          end

          def self.nfs_export(machine, ips, folders)
            if !nfs_capable?(machine)
                raise Errors::NFSServerMissing
            end

            if machine.guest.capability?(:nfs_setup_firewall)
              machine.ui.info I18n.t("vagrant_nfs_guest.guests.linux.nfs_setup_firewall")
              ips.each do |ip|
                machine.guest.capability(:nfs_setup_firewall, ip)
              end
            end

            nfs_exports_template = machine.guest.capability(:nfs_exports_template)

            nfs_opts_setup(machine, folders)

            output = Vagrant::Util::TemplateRenderer.render(
              nfs_exports_template,
              uuid: machine.id,
              ips: ips,
              folders: folders,
              user: Process.uid)

            machine.ui.info I18n.t("vagrant_nfs_guest.guests.linux.nfs_export")
            sleep 0.5

            nfs_cleanup(machine)

            retryable(on: Errors::GuestNFSError, tries: 8, sleep: 3) do
              output.split("\n").each do |line|
                machine.communicate.sudo(
                  %Q[echo '#{line}' >> /etc/exports],
                  error_class: Errors::GuestNFSError,
                  error_key: :nfs_update_exports_failed
                )
              end

              if nfs_running?(machine)
                nfs_apply_changes!(machine)
              else
                nfs_start!(machine)
              end
            end
          end

          def self.nfs_cleanup(machine)
            return if !nfs_capable?(machine)

            id = machine.id
            user = Process.uid

            # Use sed to just strip out the block of code which was inserted
            # by Vagrant
            #
            machine.communicate.sudo(
              "sed -r -e '/^# VAGRANT(-NFS_GUEST)?-BEGIN/,/^# VAGRANT(-NFS_GUEST)?-END/ d' -ibak /etc/exports",
              error_class: Errors::GuestNFSError,
              error_key: :nfs_guest_clean
            )
          end

          def self.nfs_opts_setup(machine, folders)
            folders.each do |k, opts|
              if !opts[:linux__nfs_options]
                opts[:linux__nfs_options] ||= ["rw", "no_subtree_check", "all_squash", "insecure"]
              end

              # Only automatically set anonuid/anongid if they weren't
              # explicitly set by the user.
              hasgid = false
              hasuid = false
              opts[:linux__nfs_options].each do |opt|
                hasgid = !!(opt =~ /^anongid=/) if !hasgid
                hasuid = !!(opt =~ /^anonuid=/) if !hasuid
              end

              opts[:linux__nfs_options] << "anonuid=#{opts[:map_uid]}" if !hasuid
              opts[:linux__nfs_options] << "anongid=#{opts[:map_gid]}" if !hasgid
              opts[:linux__nfs_options] << "fsid=#{opts[:uuid]}"

              # Expand the guest path so we can handle things like "~/vagrant"
              expanded_guest_path = machine.guest.capability(
                :shell_expand_guest_path, opts[:guestpath])

              retryable(on: Errors::GuestNFSError, tries: 8, sleep: 3) do
                # Do the actual creating and mounting
                machine.communicate.sudo(
                  "mkdir -p #{expanded_guest_path}",
                  error_class: Errors::GuestNFSError,
                  error_key: :nfs_create_mounts_failed
                )

                # Folder options
                opts[:owner] ||= machine.ssh_info[:username]
                opts[:group] ||= machine.ssh_info[:username]

                machine.communicate.sudo(
                  "chown #{opts[:owner]}:#{opts[:group]} #{expanded_guest_path}",
                  error_class: Errors::GuestNFSError,
                  error_key: :nfs_create_mounts_failed
                )
                machine.communicate.sudo(
                  "chmod 2775 #{expanded_guest_path}",
                  error_class: Errors::GuestNFSError,
                  error_key: :nfs_create_mounts_failed
                )
              end
            end
          end
        end
      end
    end
  end
end
