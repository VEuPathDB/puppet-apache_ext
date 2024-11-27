# If `httpd` is in $PATH, set facts for Apache
#  - name-based virtual hosts and aliases.
#  - version
require 'facter'

def httpd_cmd
  os = Facter.value(:osfamily)
  case os
  when "RedHat"
    cmd = 'httpd'
  when "Debian"
    cmd = 'apache2ctl'
  end
  Facter::Core::Execution.which(cmd) ? cmd : nil
end

#     {
#       default => {
#         port => "80",
#         conf_file => "/etc/httpd/conf.d/15-default.conf",
#         aliases => []
#       },
#       sa.vm.apidb.org => {
#         port => "80",
#         conf_file => "/etc/httpd/conf/enabled_sites/sa.vm.apidb.org.conf",
#         aliases => [
#           "sa.vm.toxodb.org",
#           "www.vm.toxodb.org"
#         ]
#       }
#     }
def httpd_vhosts
  vhosts = {}
  if ! httpd_cmd.nil?
    vhosts_raw = Facter::Core::Execution.execute(httpd_cmd + ' -S 2>/dev/null')
    namevhost = nil
    vhosts_raw.each_line do |line|
      case line
        when /port ([^ ]+) namevhost ([^ ]+) \(([^:]+):([^\)]+)\)/
          # port 80 namevhost example.domain.org (/etc/httpd/conf/enabled_sites/example.domain.org:1)
          port, namevhost, conf_file, conf_line = $1, $2, $3, $4
          vhosts[namevhost] = {
            'port'      => port,
            'conf_file' => conf_file,
            'aliases'   => []
          }
        when /        alias (.+)/
          # alias sample.domain.org
          vhosts[namevhost]['aliases'].push($1)
      end

    end
  end
  vhosts
end

#     {
#       release => "2.4.6 ",
#       major => "2",
#       minor => "4",
#       patch => "6 "
#     }
#
def httpd_version
  version = {}
  if ! httpd_cmd.nil?
    out = Facter::Core::Execution.execute(httpd_cmd + ' -v')
    out.each_line do |line|
      if line =~ /Server version:\s[^\/]+\/([^\s]+\s)/
        major, minor, patch = $1.split('.')
        version = {
          'release' => $1,
          'major'   => major,
          'minor'   => minor,
          'patch'   => patch,
        }
        break
      end
    end
  end
  version
end

Facter.add(:httpd_vhosts) do
  setcode do
    httpd_vhosts
  end
end

Facter.add(:httpd_version) do
  setcode do
    httpd_version
  end
end


