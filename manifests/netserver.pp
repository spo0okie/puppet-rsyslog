class rsyslog::netserver {
	include "rsyslog"
	include "logrotate"
	file_line { "rsyslog_udpserver_module":
		require => File['/etc/rsyslog.d'],
		path => '/etc/rsyslog.conf',
		line => "\$ModLoad imudp",
		notify => Service['rsyslog'],
	} ->
	file_line { "rsyslog_udpserver_port":
		require => File['/etc/rsyslog.d'],
		path => '/etc/rsyslog.conf',
		line => "\$UDPServerRun 514",
		notify => Service['rsyslog'],
	} ->
	file {'/etc/rsyslog.d/netmsg.conf':
		require => File['/etc/rsyslog.d'],
		source => 'puppet:///modules/rsyslog/netmsg.conf',
		mode => '0644',
		notify => Service['rsyslog']
	} ->
	file {'/etc/logrotate.d/syslog.netmsg':
		require => File['/etc/logrotate.d'],
		source => 'puppet:///modules/rsyslog/syslog.netmsg',
		mode => '0644',
	} ->
	file {'/var/log/net'
		ensure => directory,
		mode => '0777',
	}
}
