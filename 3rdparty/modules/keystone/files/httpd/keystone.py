# Copyright 2013 OpenStack Foundation
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

#
# This file was copied from https://github.com/openstack/keystone/raw/a4f29db2b8cde1b445b86218fb5543295da2092c/httpd/keystone.py
# It's only required for platforms on which it is not packaged yet.
# It should be removed when available everywhere in a package.
#

import os

from keystone.server import wsgi as wsgi_server


name = os.path.basename(__file__)

# NOTE(ldbragst): 'application' is required in this context by WSGI spec.
# The following is a reference to Python Paste Deploy documentation
# http://pythonpaste.org/deploy/
application = wsgi_server.initialize_application(name)