class debian_org {
   package { "userdir-ldap": ensure => latest;
             "zsh": ensure => latest;
             "tcsh": ensure => latest;
             "pdksh": ensure => latest;
             "ksh": ensure => latest;
             "csh": ensure => latest;
             "ntp": ensure => latest;
             "locales-all": ensure => latest;
             "sudo": ensure => latest;
             "libpam-pwdfile": ensure => latest;
             "vim": ensure => latest;
             "munin-node": ensure => latest;
             "gnupg": ensure => latest;
             "bzip2": ensure => latest;
             "less": ensure => latest;
             "ed": ensure => latest;
             "puppet": ensure => latest;

   }

}

