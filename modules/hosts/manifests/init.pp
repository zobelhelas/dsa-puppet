class hosts {

    file {
        "/etc/hosts": content => template("etc-hosts.erb");
    }
}

