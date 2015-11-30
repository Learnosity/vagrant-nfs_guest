require "vagrant"

module VagrantPlugins
  module SyncedFolderNFSGuest
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :functional
      attr_accessor :map_uid
      attr_accessor :map_gid
      attr_accessor :verify_installed

      def initialize
        super

        @functional = UNSET_VALUE
        @map_uid    = UNSET_VALUE
        @map_gid    = UNSET_VALUE
        @verify_installed = UNSET_VALUE
      end

      def finalize!
        @functional = true if @functional == UNSET_VALUE
        @map_uid = nil if @map_uid == UNSET_VALUE
        @map_gid = nil if @map_gid == UNSET_VALUE
        @verify_installed = true if @verify_installed == UNSET_VALUE
      end

      def to_s
        "NFS_Guest"
      end
    end
  end
end
