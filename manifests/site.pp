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
    include samhain

    case $smartarraycontroller {
        "true":    { include debian-proliant }
    }
    case $kvmdomain {
        "true":    { package { acpid: ensure => installed } }
    }

    case $mta {
        "exim4":   {
             case extractnodeinfo($nodeinfo, 'heavy_exim') {
                  "true":  { include exim::mx }
                  default: { include exim }
             }
        }
    }

    case $hostname {
        spohr: {
                      include nagios::server
        }
        default: {
		      include nagios::client
	}
    }

    case $apache2 {
         "true":  {
              case extractnodeinfo($nodeinfo, 'apache2_security_mirror') {
                     "true":  { include apache2::security_mirror }
                     default: { include apache2 }
              }
         }
    }

    case extractnodeinfo($nodeinfo, 'buildd') {
         "true":  { include buildd }
    }

    case $hostname {
        rietz,raff,klecker,ravel,senfl: { include named::secondary }
    }

    case $hostname {
        geo1,geo2,geo3: { include named::geodns }
    }
    case $brokenhosts {
        "true":    { include hosts }
    }
    case $hoster {
        "ubcece", "darmstadt", "ftcollins":  { include resolv }
    }
}
