class host::special {
    host { 'heininen.debian.org':
        ensure       => present,
        ip           => '82.195.75.98',
        host_aliases => ['heininen'],
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
