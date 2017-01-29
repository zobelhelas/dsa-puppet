For content which can be served via the Apache web server, possibly with a
custom configuration, Debian runs its static mirroring infrastructure. A key
advantage of that infrastructure is the higher availability it provides:
whereas individual virtual machines are power-cycled for scheduled maintenance
(e.g. kernel upgrades), static mirroring machines are removed from the DNS
entry static.debian.org during their maintenance.

The term static mirroring infrastructure includes:

 • components, specifying the data source and other config options.
   See modules/roles/misc/static-components.yaml
 • a masterhost for each component, responsible only for distributing data,
   not for serving data to end users.
 • machines with the static_mirror role configured in hieradata/common.yaml
 • a few scripts around rsync(1)

All of the above is managed via Puppet, for details see the files in
modules/roles/*/static-mirroring.

When data changes, the data source is responsible for running
static-update-component, which instructs the masterhost via SSH to run
static-master-update-component.

static-master-update-component transfers a new copy of the source data to the
masterhost using rsync(1) and, upon successful copy, swaps it with the current
copy.

The current copy on the masterhost is then distributed to all actual mirrors,
again placing a new copy alongside their current copy using rsync(1).

Once the data successfully made it to all mirrors, the mirrors are instructed
to swap the new copy with their current copy, at which point the updated data
will be served to end users.
