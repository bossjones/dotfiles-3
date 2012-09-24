class silas::screen {
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
}
