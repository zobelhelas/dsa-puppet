class roles::static_source inherits roles::static_base {
    file {
        '/etc/ssh/userkeys/staticsync':
            content => template('roles/static-mirroring/static-mirror-authorized_keys.erb'),
            ;
        '/usr/local/bin/static-mirror-ssh-wrap':
            source  => "puppet:///modules/roles/static-mirroring/static-mirror-ssh-wrap",
            mode => 555,
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
