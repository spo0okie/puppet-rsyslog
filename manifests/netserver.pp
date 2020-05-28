class rsyslog::netserver {
	include "rsyslog"
	include "logrotate"
	#тут возникла неувязочка, т.к. на последнем дебиане и на убунте почему-то другие команды для запуска
	#прослушивания порта 514, потому вкорячили вот этот вот свитч-кейс
	#на самом деле возможно надо еще и версии (мажорные) проверять, но если гдето не заработает - вкорячим
	case $::operatingsystem {
		'CentOS','RedHat': {
			case $::operatingsystemmajrelease {
				'6','7': {
					$udp_module_cmd = "\$ModLoad imudp"
					$udp_module_port = "\$UDPServerRun 514"
				}
				default: {
					$udp_module_cmd = 'module(load="imudp")'
					$udp_module_port = 'input(type="imudp" port="514")'
				}
			}		
		}
		'Ubuntu','Debian': {
			#Старые дебы и убунты я не юзаю, только если чтото переношу на новые, 
			#потому сразу вколачиваем код для нового синтаксиса
			$udp_module_cmd = 'module(load="imudp")'
			$udp_module_port = 'input(type="imudp" port="514")'
		}

		default: {
			$udp_module_cmd = 'module(load="imudp")'
			$udp_module_port = 'input(type="imudp" port="514")'
		}
	}
	file_line { "rsyslog_udpserver_module":
		require => File['/etc/rsyslog.d'],
		path => '/etc/rsyslog.conf',
		line => $udp_module_cmd,
		notify => Service['rsyslog'],
	} ->
	file_line { "rsyslog_udpserver_port":
		require => File['/etc/rsyslog.d'],
		path => '/etc/rsyslog.conf',
		line => $udp_module_port,
		notify => Service['rsyslog'],
	} ->
	file {'/etc/rsyslog.d/10-netmsg.conf':
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
	file {'/var/log/net':
		ensure => directory,
		mode => '0777',
	}
}
