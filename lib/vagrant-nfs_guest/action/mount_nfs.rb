module VagrantPlugins
  module SyncedFolderNFSGuest
    module Action
      class MountNFS

        def initialize(app,env)
          @app = app
          @logger = Log4r::Logger.new("vagrant-nfs_guest::action::mount_nfs")
        end

        def call(env)
          @machine = env[:machine]

          @app.call(env)

          if @machine.state.id == :running
            raise Vagrant::Errors::NFSNoHostIP if !env[:nfs_host_ip]
            raise Vagrant::Errors::NFSNoGuestIP if !env[:nfs_machine_ip]

            machine_ip = env[:nfs_machine_ip]
            machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

            # Mount guest NFS folders
            @machine.ui.info(I18n.t("vagrant_nfs_guest.actions.vm.nfs.mounting"))
            folders = @machine.config.vm.synced_folders

            @machine.env.host.capability(
              :nfs_mount,
              @machine.ui, @machine.id, machine_ip, folders
            )
          end
        end
      end
    end
  end
end
