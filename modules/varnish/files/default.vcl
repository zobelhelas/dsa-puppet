##
## THIS FILE IS UNDER PUPPET CONTROL. DON'T EDIT IT HERE.
## USE: git clone git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
##
vcl 4.0;

backend default {
	.host = "127.0.0.1";
	.port = "80";
}

sub vcl_backend_response {
/*        if (beresp.status != 200 && beresp.status != 403 && beresp.status != 404 && beresp.status != 301 && beresp.status != 302) {
                return(restart);
        }*/

        # if I cant connect to the backend, ill set the grace period to be 600 seconds to hold onto content
        set beresp.ttl = 600s;
        set beresp.grace = 600s;

        if (beresp.status >= 500) {
                set beresp.ttl = 0.1s;
        }
        unset beresp.http.Set-Cookie;
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
