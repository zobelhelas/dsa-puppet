##
## THIS FILE IS UNDER PUPPET CONTROL. DON'T EDIT IT HERE.
## USE: git clone git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
##


#   SSL Engine Switch:
#   Enable/Disable SSL for this virtual host.
SSLEngine on

#
#   Some MIME-types for downloading Certificates and CRLs
#   
AddType application/x-x509-ca-cert .crt
AddType application/x-pkcs7-crl    .crl

#   Add STS
Header add Strict-Transport-Security "max-age=604800"

