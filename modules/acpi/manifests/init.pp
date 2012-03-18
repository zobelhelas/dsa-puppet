class acpi {
    if ! $debarchitecture in ['kfreebsd-amd64', 'kfreebsd-i386'] {
        package {
            acpid: ensure => installed
        }

        if $lsbdistcodename != 'lenny' {
            package {
                acpi-support-base: ensure => installed
            }
        }
    }
}
