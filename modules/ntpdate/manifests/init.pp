class ntpdate {
    case getfromhash($nodeinfo, 'broken-rtc') {
        true: {
            package {
                ntpdate: ensure => installed;
                lockfile-progs: ensure => installed;
            }
            file {
                "/etc/default/ntpdate":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntpdate/etc-default-ntpdate" ],
                    ;
            }
        }
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
