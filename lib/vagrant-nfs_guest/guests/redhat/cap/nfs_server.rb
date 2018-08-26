module VagrantPlugins
  module SyncedFolderNFSGuest
    module GuestRedHat
      module Cap
        class NFSServer

          def self.systemd?(machine)
            machine.communicate.test("test $(ps -o comm= 1) == 'systemd'")
          end

          def self.firewalld?(machine)
            machine.communicate.test("test $(command -v firewall-cmd)")
          end

          def self.firewalld_enabled?(machine)
            machine.communicate.test("test $(firewall-cmd --state) == 'running'")
          end

          def self.nfs_server_install(machine)
            machine.communicate.sudo("dnf -y install nfs-utils")

            if systemd?(machine)
              machine.communicate.sudo("systemctl enable rpcbind nfs-server")
            else
              machine.communicate.sudo("chkconfig nfs on")

            end
          end

          def self.nfs_setup_firewall(machine, ip)
            if not systemd?(machine)
              # centos 6.5 has iptables on by default is would seem
              machine.communicate.sudo(
                "sed -i \"s/#LOCKD_/LOCKD_/\" /etc/sysconfig/nfs"
              )
              machine.communicate.sudo(
                "sed -i \"s/#MOUNTD_PORT/MOUNTD_PORT/\" /etc/sysconfig/nfs"
              )
              machine.communicate.sudo(
                "iptables -I INPUT -m state --state NEW -p udp -m multiport " +
                "--dport 111,892,2049,32803 -s #{ip}/32 -j ACCEPT"
              )
              machine.communicate.sudo(
                "iptables -I INPUT -m state --state NEW -p tcp -m multiport " +
                "--dport 111,892,2049,32803 -s #{ip}/32 -j ACCEPT"
              )

              nfs_start_command(machine)
            end

            if firewalld?(machine) #and firewalld_enabled?(machine)
              # add nfs rules if we have firewalld and it's enabled
              machine.communicate.sudo("firewall-cmd --permanent --add-service=nfs")
              machine.communicate.sudo("firewall-cmd --permanent --add-service=mountd")
              machine.communicate.sudo("firewall-cmd --permanent --add-service=rpc-bind")
              machine.communicate.sudo("firewall-cmd --reload")
            end
          end

          def self.nfs_server_installed(machine)
            if systemd?(machine)
              machine.communicate.test("systemctl status nfs-server.service")
            else
              machine.communicate.test("service nfs status")
            end
          end

          def self.nfs_check_command(machine)
            if systemd?(machine)
              machine.communicate.test(
                "systemctl status rpcbind nfs-server"
              )
            else
              machine.communicate.test(
                "service nfs status"
              )
            end
          end

          def self.nfs_start_command(machine)
            if systemd?(machine)
              machine.communicate.sudo(
                "systemctl start rpcbind nfs-server",
                error_class: Errors::GuestNFSError,
                error_key: :nfs_start_failed
              )
            else
              ['rpcbind', 'nfs'].each do |i|
                machine.communicate.sudo(
                  "service #{i} restart",
                  error_class: Errors::GuestNFSError,
                  error_key: :nfs_start_failed
                )
              end
            end
          end
        end
      end
    end
  end
end
