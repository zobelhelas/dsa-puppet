# dsa-puppet

## Reference Documentation

- [Puppet Language: Summary][1]
- [Puppet Language: Type Reference][2]
- [Puppet Language: Function Reference][3]

## HOWTOs

### how to deploy a development environment

    apt-get install facter   # >= 1.6.2
    apt-get install puppet   # >= 2.7.6
    apt-get install pcregrep
    apt-get install puppet-lint
    git clone ssh://username@handel.debian.org/srv/puppet.debian.org/git/dsa-puppet.git /path/to/local/repo
    make -C /path/to/local/repo git_hooks  # CRITICAL

### how to validate manifest files

    puppet parser validate </path/to/manifest/file>
    puppet-lint --no-2sp_soft_tabs-check --no-hard_tabs-check --no-80chars-check </path/to/manifest/file>

### how to test changes

Once you commit your changes and push them to the primary repository, you
can test your changes on a Debian machine using:

    puppet agent --test --noop

Note, however, that once the changes are pushed, the changes are live to
all Debian machines and it is only a matter of time for the agent to run.

### how to configure vim

For Vim users, tools/vim contains some files that make life easier. You may
install them into your ~/.vim using:

    make -C /path/to/local/repo vim_helpers

Alternately, use [gmarik/vundle][4] or [tpope/pathogen][5] to install
[rodjek/vim-puppet][6].


[1]: http://docs.puppetlabs.com/puppet/latest/reference/lang_summary.html
[2]: http://docs.puppetlabs.com/references/stable/type.html
[3]: http://docs.puppetlabs.com/references/stable/function.html
[4]: https://github.com/gmarik/vundle
[5]: https://github.com/tpope/vim-pathogen
[6]: https://github.com/rodjek/vim-puppet
