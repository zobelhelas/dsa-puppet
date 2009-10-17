class munin-node::vsftpd inherits munin-node {
        activate_munin_check {
                "vsftpd":;
                "ps_vsftpd": script => "ps_";
        }
}

