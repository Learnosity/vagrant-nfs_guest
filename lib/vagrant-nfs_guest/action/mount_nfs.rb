module VagrantPlugins
  module SyncedFolderNFSGuest
    module Action
      class MountNFS

        def initialize(app,env)
          @app = app
          @logger = Log4r::Logger.new("vagrant-nfs_guest::action::unmount_nfs")
        end

        def call(env)
          @machine = env[:machine]

          # because we're hooked into Vagrant::Action::Builtin::SyncedFolders and
          # Vagrant::Action::Builtin::WaitForCommunicator we need to figure out
          # if we're 'up'ing from 'poweroff' or 'up'ing from 'suspend'
          # If 'poweroff' we get called twice once with state.id = 'poweroff' and
          # again with state.id = 'running'. This toggle around @app.call() allows
          # the second call to actually do the mount after the SyncFolder setup
          # has completed properly. If 'running' well then we just do the mount
          # as we're obvioulsy coming from a 'suspended' instance. Stupid bug.
          if !env[:nfs_guest_first_state]
            env[:nfs_guest_first_state] = @machine.state.id
          end

          @app.call(env)

          # ... and also deal with 'reload' :weary:
          if env[:nfs_guest_first_state] == :poweroff and env[:action_name] != :machine_action_reload
            env[:nfs_guest_first_state] = @machine.state.id
            return
          end

          if @machine.state.id == :running
            if !@machine.provider.capability?(:nfs_settings)
              raise SyncedFolderNFSGuest::Errors::ProviderNFSSettingsCapMissing
            end

            # grab the folders to check if any use nfs_guest and require host networking
            folders = @machine.config.vm.synced_folders

            nfs_guest = false
            nfs_guest_folders = {}

            folders.each do |name, opts|
              if opts[:type] == :nfs_guest && opts[:disabled] == false
                nfs_guest = true
                opts[:hostpath] = File.expand_path(opts[:hostpath], env[:root_path])
                nfs_guest_folders[name] = opts.dup
              end
            end

            if not nfs_guest
              return
            end

            # grab the ips from the provider
            host_ip, machine_ip = @machine.provider.capability(:nfs_settings)

            raise Vagrant::Errors::NFSNoHostIP if !host_ip
            raise Vagrant::Errors::NFSNoGuestIP if !machine_ip

            machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

            if @machine.config.nfs_guest.verify_installed
              if @machine.guest.capability?(:nfs_server_installed)
                installed = @machine.guest.capability(:nfs_server_installed)
                if installed
                  # Mount guest NFS folders
                  @machine.ui.info(I18n.t("vagrant_nfs_guest.actions.vm.nfs.mounting"))
                  @machine.env.host.capability(:nfs_mount, @machine.ui, @machine.id, machine_ip, nfs_guest_folders)
                end
              end
            end
          end
        end
      end
    end
  end
end
