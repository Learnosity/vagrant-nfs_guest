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

            folders.each do |name, opts|
              if opts[:type] == :nfs_guest
                opts[:hostpath] = File.expand_path(opts[:hostpath], env[:root_path])
                if env[:force_halt]
                  # If this is a force halt, force unmount the nfs shares.
                  opts[:unmount_options] = opts.fetch(:unmount_options, []) << '-f'
                  # We have to change the working dir if inside a hostmount to prevent "No such file or directory - getcwd" errors.
                  if Dir.pwd.start_with?(opts[:hostpath])
                    Dir.chdir("#{opts[:hostpath]}/..")
                  end
                end
              end
            end

            @machine.env.host.capability(:nfs_unmount, @machine.ui, folders)
          end

          @app.call(env)

        end
      end
    end
  end
end
