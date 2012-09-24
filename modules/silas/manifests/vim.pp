class silas::vim {
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
}
