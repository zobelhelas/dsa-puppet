##
## THIS FILE IS UNDER PUPPET CONTROL. DON'T EDIT IT HERE.
## USE: git clone git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
##


#   SSL Engine Switch:
#   Enable/Disable SSL for this virtual host.
SSLEngine on

#   SSL Protocol support:
#   List the protocol versions which clients are allowed to
#   connect with. Disable SSLv2 by default (cf. RFC 6176).
SSLProtocol all -SSLv2

#
#   Some MIME-types for downloading Certificates and CRLs
#   
AddType application/x-x509-ca-cert .crt
AddType application/x-pkcs7-crl    .crl

#   SSL Cipher Suite:
#   List the ciphers that the client is permitted to negotiate.
#   See the mod_ssl documentation for a complete list.
SSLCipherSuite ECDHE-RSA-AES256-SHA384:AES256-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH:!AESGCM
SSLHonorCipherOrder on

#   Add STS
Header add Strict-Transport-Security "max-age=604800"

