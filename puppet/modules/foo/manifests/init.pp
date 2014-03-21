class foo($fox = "") {
  require git
  notify {
    "The fox says: ${fox}": ;
  }
  vcsrepo {
    '/tmp/ud032':
      ensure => present,
      provider => git,
      source => 'git://github.com/udacity/ud032.git',
  }
}
