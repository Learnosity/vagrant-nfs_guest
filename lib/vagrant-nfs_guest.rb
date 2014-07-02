require "pathname"

require "vagrant-nfs_guest/plugin"
require "vagrant-nfs_guest/hosts/bsd/plugin"

module VagrantPlugins
  module SyncedFolderNFSGuest
    lib_path = Pathname.new(File.expand_path("../vagrant-nfs_guest", __FILE__))
    autoload :Errors, lib_path.join("errors")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    I18n.load_path << File.expand_path("templates/locales/en.yml", source_root)
    I18n.reload!
  end
end
