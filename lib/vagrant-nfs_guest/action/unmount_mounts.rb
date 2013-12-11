module VagrantPlugins
  module SyncedFolderNFSGuest
    module Action
      class UnmountMounts
        def initialize(app,env)
          @app = app
          @logger = Log4r::Logger.new("vagrant::action::vm::nfs_guest")
        end

        def call(env)
          @machine = env[:machine]
          @app.call(env)

          folders = @machine.config.vm.synced_folders
          @machine.env.host.unmount_nfs_folders(folders)
        end
      end
    end
  end
end
