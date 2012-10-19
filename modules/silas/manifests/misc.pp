class silas::misc {
  file { "${home}/.gdbinit":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/gdbinit',
  }
  file { "${home}/.gemrc":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/gemrc',
  }
}
