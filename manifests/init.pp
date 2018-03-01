class rsyslog {
	case $::kernel {
		'Linux': {
			package {'rsyslog':
				ensure => installed
			} ->
			service {'rsyslog':
				ensure => running,
				enable => true
			}
			file {'/etc/rsyslog.d':
				ensure => directory,
			}
		}
	}
}
