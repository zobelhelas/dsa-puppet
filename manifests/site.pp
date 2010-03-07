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
                  true:    { include exim::mx }
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
         true:  {
             include buildd
             case $kernel {
                 'Linux': {
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
        logtest01,geo1,geo2,geo3,bartok,senfl,beethoven,piatti,saens,villa,lobos,raff,gluck,schein,wieck,steffani: { include ferm }
    }
    case $hostname {
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
