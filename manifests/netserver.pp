class rsyslog::netserver {
	include "logrotate"
	ini_setting {'rsyslog_udpserver_module':
		path => '/etc/rsyslog.conf',
		ensure => present,
		section => '',
		setting => '$ModLoad',
		value => 'imudp',
		notify => Service['rsyslog'],
	} ->
	ini_setting {'rsyslog_udpserver_port':
		path => '/etc/rsyslog.conf',
		ensure => present,
		section => '',
		setting => '$UDPServerRun',
		value => '514',
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
	}
}
