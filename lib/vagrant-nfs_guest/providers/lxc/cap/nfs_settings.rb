module VagrantPlugins
  module SyncedFolderNFSGuest
    module ProviderLxc
      module Cap

	def self.read_host_ip(machine)
          machine.communicate.execute 'echo $SSH_CLIENT' do |buffer, output|
            return output.chomp.split(' ')[0] if buffer == :stdout
	  end
	end

        def self.nfs_settings(machine)
          host_ip  = self.read_host_ip(machine)
          machine_ip = machine.provider.ssh_info[:host]

          raise Vagrant::Errors::NFSNoHostonlyNetwork if !host_ip || !machine_ip

          return host_ip, machine_ip
        end
      end
    end
  end
end
