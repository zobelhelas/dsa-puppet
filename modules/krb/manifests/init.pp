class krb {
    file {
        "/etc/krb5.conf":
            content => template("krb/krb5.conf.erb"),
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
