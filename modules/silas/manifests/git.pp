class silas::git {
  file { "${home}/.gitconfig":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    content => template('silas/gitconfig.erb'),
  }
}
