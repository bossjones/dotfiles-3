class silas::tmux {
  file { "${home}/.tmux.conf":
    ensure  => present,
    mode    => '0644',
    seltype => 'user_home_t',
    source  => 'puppet:///modules/silas/tmux.conf',
  }
}
