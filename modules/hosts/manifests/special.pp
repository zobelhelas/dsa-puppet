class hosts::special {
    host { 'heininen.debian.org-v4':
        ensure       => present,
        name         => 'heininen.debian.org',
        ip           => '82.195.75.98',
        host_aliases => ['heininen'],
    }
    host { 'heininen.debian.org-v6':
        ensure       => present,
        name         => 'heininen.debian.org',
        ip           => '2001:41b8:202:deb:214:22ff:fe13:492b',
        host_aliases => ['heininen'],
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
