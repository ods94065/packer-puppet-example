# Sets up a student home directory with a sample code directory.
# Note: this would perhaps be better as a define, not a class. I use a class
# here so that I can demonstrate the use of Hiera.
class student($user, $fullname) {
  require git
  user {
    $user:
      ensure => present,
      comment => $fullname,
      managehome => true,
      shell => '/bin/bash',
  }
  file {
    "/home/${user}/src":
      ensure => directory,
      mode => 755,
      require => User[$user],
  }
  vcsrepo {
    "/home/${user}/src/ud032":
      ensure => present,
      provider => git,
      source => 'git://github.com/udacity/ud032.git',
      require => File["/home/${user}/src"],
  }
}
