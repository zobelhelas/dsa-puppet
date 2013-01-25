##
## THIS FILE IS UNDER PUPPET CONTROL. DON'T EDIT IT HERE.
## USE: git clone git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
##

backend holter {
        # holter.debian.org
        .host = "194.177.211.202";
        .port = "80";
}
backend powell {
        # powell.debian.org
        .host = "87.106.64.223";
        .port = "80";
}

sub vcl_recv {

        # Add a unique header containing the client address
        remove req.http.X-Forwarded-For;
        set    req.http.X-Forwarded-For = req.http.rlnclientipaddr;

        ### restart logic, this will redefine the backends if vcl_restart has been triggered
        if (req.restarts == 0) {
                set req.backend = holter;
        } else if (req.restarts == 1) {
                set req.backend = powell;
        } else if (req.restarts == 2) {
                set req.backend = holter;
        } else {
                set req.backend = holter;
        }


        if (req.request == "GET" && req.url ~ "^/search?") {
                return(pass);
        }
        if (req.request == "GET" && req.url ~ "^/(squeeze|wheezy|sid|experimental|stable|testing|unstable|rc-buggy|squeezy-backports|lenny-backports|Pics)/") {
                return(lookup);
        }
}

sub vcl_fetch {
        if (beresp.status != 200 && beresp.status != 403 && beresp.status != 404 && beresp.status != 301 && beresp.status != 302) {
                return(restart);
        }

        # if i cant connect to the backend, ill set the grace period to be 600 seconds to hold onto content
        set beresp.ttl = 600s;
        set beresp.grace = 600s;

        if (beresp.status == 404) {
                set beresp.ttl = 0s;
        }

        if (beresp.status >= 500) {
                set beresp.ttl = 0s;
        }

        if (req.request == "GET" && req.url ~ "^/search?") {
                set beresp.ttl = 0s;
        }

        if (req.request == "GET" && req.url ~ "^/(squeeze|wheezy|sid|experimental|stable|testing|unstable|rc-buggy|squeezy-backports|lenny-backports|Pics)/") {
                set beresp.ttl = 3600s;
        }


        set beresp.http.X-Cacheable = "YES";
        return(deliver);
}


sub vcl_deliver {

        set resp.http.X-Served-By = server.hostname;
        if (obj.hits > 0) {
                set resp.http.X-Cache = "HIT";
                set resp.http.X-Cache-Hits = obj.hits;
        } else {
                set resp.http.X-Cache = "MISS";
        }

        return(deliver);
}
