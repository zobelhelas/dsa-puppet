class hosts {

    file {
        "/etc/hosts": content => template("hosts/etc-hosts.erb");
    }
}

