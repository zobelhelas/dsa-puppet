class buildd {
   package {
     "sbuild": ensure => installed;
     "buildd": ensure => installed;
     "buildd-builder-meta": ensure => installed;
     "apt-transport-https": ensure => installed;
   }

   file {
      "/etc/apt/sources.list.d/buildd.list":
             source => "puppet:///files/etc/apt/sources.list.d/buildd.list",
             require => Package["apt-transport-https"],
   }

# THIS IS NOT READY YET
# also needs:
#  apt key on the system:
# -----BEGIN PGP PUBLIC KEY BLOCK-----
# Version: GnuPG v1.4.9 (GNU/Linux)
# 
# mQENBEm1IOQBCAC2D/Q3tcB+/zRx8/O4ry4hvP3JTLB+zCXcyAcIyzPdgmxNXQUZ
# IOPSIMluiJfh9Dbgwjxm9oWTkP2LobcfVzIlHA9nVonW42rhhaYJd7yQ8xQ6u15g
# 7SPNO8b8yinqm+140Sh32PZj/5YGdFf1YpJ82la8PmNFkpLQlP+Kv2hzusun1/fQ
# Ui8g81gHq+vO5XTKW06yMk87a4SHeSFEtxjIpivAx9iIpQCF8RmPs7+EbGpG1xpn
# pjD8QMzmls8yPFl/0+xh+tvIZoGogIJHDo3I1vDEUuEMqoISnBB+BjWRrcJylQW0
# mbNyiv2AJmNEZLZG3+0KdT9txs7ZKQfsSU6VABEBAAG0J2J1aWxkZC5kZWJpYW4u
# b3JnIGFyY2hpdmUga2V5IDIwMDkvMjAxMIkBPAQTAQIAJgUCSbUg5AIbAwUJA8Jn
# AAYLCQgHAwIEFQIIAwQWAgMBAh4BAheAAAoJEHxDG3/7kJSE/4gIAJXwWs1IaOVf
# qkQpx+ijdyLqoZWpOYeX3Vo9FF2Lk/3+tBol8QFoQoSvrQWg+aP+SXlL1PzpEOvs
# 87uqRzPvwK7B7eHlzY0mGpshXEGniHNVK4ZBh3svrVN3LwqV6lgHkNWZkBczDfvi
# E8du/UXOL7lCADqjZCPRuwGPwkWp32MbZzwRHP0pRyXttRXTDUQXwM6TUhGaHxsB
# A4K5AUsooz4PCpIiUwVmle7kGz+NrI+bbyFNJBGnSxwluxGsJayX9kaqbq9JDhsM
# i+nhFOCOXomKSbJAaoQZnpGY4fFhk14UdM7EQ9CsEpvBu2CeZu2CibmDR8hPuGMV
# duy/LOSZsT0=
# =680o
# -----END PGP PUBLIC KEY BLOCK-----
#



}
