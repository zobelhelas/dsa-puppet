class hosts {

    file {
        "/etc/hosts": content => template("hosts/etc-hosts.erb");
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
