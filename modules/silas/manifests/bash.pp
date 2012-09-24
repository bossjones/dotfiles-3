class silas::bash {
  file { "${home}/.hushlogin":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => '',
  }

  file { "${home}/.bash_env":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => template('silas/bash_env.erb'),
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
    require => File["${home}/.scripts"],
  }

  file { "${home}/.scripts":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/scripts',
  }
}
