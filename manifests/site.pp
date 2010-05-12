Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

File {
    owner   => root,
    group   => root,
    mode    => 444,
    ensure  => file,
}

Exec {
    path => "/usr/bin:/usr/sbin:/bin:/sbin"
}

node default {
    $localinfo = yamlinfo('*', "/etc/puppet/modules/debian-org/misc/local.yaml")
    $nodeinfo  = nodeinfo($fqdn, "/etc/puppet/modules/debian-org/misc/local.yaml")
    $hoster    = whohosts($nodeinfo, "/etc/puppet/modules/debian-org/misc/hoster.yaml")
    $keyinfo   = allnodeinfo("sshRSAHostKey", "ipHostNumber")
    notice("hoster for ${fqdn} is ${hoster}")

    $mxinfo   = allnodeinfo("mXRecord")

    include munin-node
    include sudo
    include ssh
    include debian-org
    include monit
    include apt-keys
    include ntp

    include motd

    case $hostname {
        finzi,fano,fasch,field:    { include kfreebsd }
    }

    case $smartarraycontroller {
        "true":    { include debian-proliant }
    }
    case $kvmdomain {
        "true":    { package { acpid: ensure => installed } }
    }
    case $mptraid {
        "true":    { include "raidmpt" }
    }

    case $mta {
        "exim4":   {
             case extractnodeinfo($nodeinfo, 'heavy_exim') {
                  'true':  { include exim::mx }
                  default: { include exim }
             }
        }
    }

    case extractnodeinfo($nodeinfo, 'muninmaster') {
        true: { include munin-node::master }
    }

    case extractnodeinfo($nodeinfo, 'nagiosmaster') {
        true:    { include nagios::server }
        default: { include nagios::client }
    }

    case $apache2 {
         "true":  {
              case extractnodeinfo($nodeinfo, 'apache2_security_mirror') {
                     true:    { include apache2::security_mirror }
                     default: { include apache2 }
              }
         }
    }

    case extractnodeinfo($nodeinfo, 'buildd') {
         'true':  {
             include buildd
             case $kernel {
                 Linux: {
                     include ferm
                 }
             }
         }
    }

    case $hostname {
        klecker,ravel,senfl,orff: { include named::secondary }
        geo1,geo2,geo3:           { include named::geodns }
        bartok,schein,steffani:   { include named::recursor }
    }

    case $hostname {
        powell,logtest01,geo1,geo2,geo3,bartok,senfl,beethoven,piatti,saens,villa,lobos,raff,gluck,schein,wieck,steffani,ball,handel,tchaikovsky: { include ferm }
    }
    case $hostname {
        zandonai,zelenka: {
           @ferm::rule { "dsa-zivit-rrdcollect":
               description  => "port 6666 for rrdcollect for zivit",
               rule         => "&SERVICE_RANGE(tcp, 6666, ( 10.130.18.71 ))"
           }
           @ferm::rule { "dsa-zivit-zabbix":
               description  => "port 10050 for zabbix for zivit",
               rule         => "&SERVICE_RANGE(tcp, 10050, ( 10.130.18.76 ))"
           }
        }
        piatti: {
           @ferm::rule { "dsa-udd-stunnel":
               description  => "port 8080 for udd stunnel",
               rule         => "&SERVICE_RANGE(tcp, http-alt, ( 192.25.206.16 70.103.162.29 217.196.43.134 ))"
           }
        }
	senfl: {
	   @ferm::rule { "dsa-rsync":
		    domain          => "(ip ip6)",
		    description     => "Allow rsync access",
		    rule            => "&SERVICE(tcp, 873)"
	   }
        }
        saens,villa,lobos,raff,gluck,schein,wieck,steffani: {
           @ferm::rule { "dsa-ftp":
		    domain          => "(ip ip6)",
		    description     => "Allow ftp access",
		    rule            => "&SERVICE(tcp, 21)"
           }
	   @ferm::rule { "dsa-rsync":
		    domain          => "(ip ip6)",
		    description     => "Allow rsync access",
		    rule            => "&SERVICE(tcp, 873)"
	   }
        }
        ancina,zelenka: {
	   @ferm::rule { "dsa-time":
		    description     => "Allow time access",
		    rule            => "&SERVICE_RANGE(tcp, time, \$HOST_NAGIOS_V4)"
	   }
        }
        handel: {
	   @ferm::rule { "dsa-puppet":
		    description     => "Allow puppet access",
		    rule            => "&SERVICE_RANGE(tcp, 8140, \$HOST_DEBIAN_V4)"
	   }
	   @ferm::rule { "dsa-puppet-v6":
		    domain          => 'ip6',
		    description     => "Allow puppet access",
		    rule            => "&SERVICE_RANGE(tcp, 8140, \$HOST_DEBIAN_V6)"
	   }
        }
	powell: {
	   @ferm::rule { "dsa-powell-v6-tunnel":
		    description     => "Allow powell to use V6 tunnel broker",
		    rule            => "proto ipv6 saddr 212.227.117.6 jump ACCEPT"
	   }
	   @ferm::rule { "dsa-powell-btseed":
                    domain          => "(ip ip6)",
		    description     => "Allow powell to seed BT",
		    rule            => "proto tcp dport 8000:8100 jump ACCEPT"
	   }
	}
	beethoven: {
	   @ferm::rule { "dsa-merikanto-beethoven":
		    description     => "Allow merikanto",  # for nfs, and that uses all kind of ports by default.
		    rule            => "source 172.22.127.147 interface bond0 jump ACCEPT",
	   }
	}

    }
    case $brokenhosts {
        "true":    { include hosts }
    }
    case $hoster {
        "ubcece", "darmstadt", "ftcollins", "grnet":  { include resolv }
    }
    case $portforwarder_user_exists {
        "true":    { include portforwarder }
    }
    include samhain
}
