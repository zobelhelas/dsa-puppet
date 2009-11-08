class munin-node::vsftpd inherits munin-node {
        package { 
                "logtail": ensure => installed;
        }
        activate_munin_check {
                "vsftpd":;
                "ps_vsftpd": script => "ps_";
        }
}

