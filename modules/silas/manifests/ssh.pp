class silas::ssh {
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
}
