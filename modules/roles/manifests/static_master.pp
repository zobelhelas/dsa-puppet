class roles::static_master inherits roles::static_base {
    file {
        '/etc/ssh/userkeys/staticsync':
            content => template('roles/static-master-authorized_keys.erb'),
            ;
        '/usr/local/bin/static-master-run':
            source  => "puppet:///modules/roles/static-mirroring/static-master-run",
            mode => 555,
            ;
        '/usr/local/bin/static-master-ssh-wrap':
            source  => "puppet:///modules/roles/static-mirroring/static-master-ssh-wrap",
            mode => 555,
            ;
        '/usr/local/bin/static-master-update-component':
            source  => "puppet:///modules/roles/static-mirroring/static-master-update-component",
            mode => 555,
            ;

        '/etc/static-components.conf':
            source  => "puppet:///modules/roles/static-mirroring/static-components.conf",
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
