require 'json'
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

          if @machine.state.id == :running

            raise Vagrant::Errors::NFSNoHostIP if !env[:nfs_guest_host_ip]
            raise Vagrant::Errors::NFSNoGuestIP if !env[:nfs_guest_machine_ip]

            machine_ip = env[:nfs_guest_machine_ip]
            machine_ip = [machine_ip] if !machine_ip.is_a?(Array)

            # Mount guest NFS folders
            @machine.ui.info(I18n.t("vagrant_nfs_guest.actions.vm.nfs.mounting"))
            folders = @machine.config.vm.synced_folders

            @machine.env.host.capability(
              :nfs_mount,
              @machine.ui, @machine.id, machine_ip, folders
            )
          end

          @app.call(env)

        end
      end
    end
  end
end
