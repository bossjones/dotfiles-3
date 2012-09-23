class silas($email='silas@sewell.org') {
  $home = "/home/${id}"

  file { "${home}/.gitconfig":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => template('silas/gitconfig.erb'),
  }

  file { "${home}/.vimrc":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => template('silas/vimrc.erb'),
  }

  file { "${home}/.vim":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/vim',
  }

  file { "${home}/.gdbinit":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/gdbinit',
  }

  file { "${home}/.hushlogin":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => '',
  }

  file { "${home}/.screenrc":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/screenrc',
  }

  file { "${home}/.screen":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/screen',
  }

  file { "${home}/.scripts":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/scripts',
  }

  file { "${home}/.ssh":
    ensure  => directory,
    mode    => '0700',
    seltype => 'ssh_home_t',
  }

  file { "${home}/.ssh/config":
    ensure  => directory,
    mode    => '0700',
    seltype => 'ssh_home_t',
    content => template('silas/ssh/config.erb'),
  }

  file { "${home}/.tmux.conf":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/tmux.conf',
  }

  file { "${home}/.bash_profile":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/bash_profile',
  }

  file { "${home}/.bashrc":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/bashrc',
  }

}
