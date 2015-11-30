module VagrantPlugins
  module SyncedFolderNFSGuest
    module Action
      class UnmountNFS

        def initialize(app,env)
          @app = app
          @logger = Log4r::Logger.new("vagrant-nfs_guest::action::unmount_nfs")
        end

        def call(env)
          @machine = env[:machine]

          if @machine.state.id == :running
            # unmount any host mounted NFS folders
            @machine.ui.info(I18n.t("vagrant_nfs_guest.actions.vm.nfs.unmounting"))
            folders = @machine.config.vm.synced_folders

            @machine.env.host.capability(:nfs_unmount, @machine.ui, folders)
          end

          @app.call(env)

        end
      end
    end
  end
end
