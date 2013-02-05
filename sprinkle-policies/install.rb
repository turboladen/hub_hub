package :mysql, :provides => :database do
  description 'MySQL Database'
  yum %w( mysql-server )

  verify do
    has_yum 'mysql-server'
  end
end

package :apache, :provides => :webserver do
  description 'Apache 2 HTTP Server'
  yum %w( httpd )
  transfer 'sprinkle-policies/files/httpd.conf.erb', '/etc/httpd/conf/httpd.conf',
    render: true,
    locals: {
      host: 'chat-test.mindhub.org'
    }

  verify do
    has_yum 'httpd'
    file_contains '/etc/httpd/conf/httpd.conf', 'passenger'
  end
end

package :passenger do
  gem :passenger, sudo: false

  verify do
    has_gem 'passenger'
  end
end

package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  yum %w( git )

  verify do
    has_yum 'git'
  end
end

package :sudoers do
  transfer 'sprinkle-policies/files/sudoers.erb', '/etc/sudoers', render: true, locals: {
    host: 'chat-test.mindhub.org'
  }

  verify do
    file_contains '/etc/sudoers', 'vagrant ALL=(ALL)'
  end
end

policy :mindhub, :roles => :app do
  requires :database
  requires :webserver
  requires :scm
  requires :sudoers
  requires :passenger
end

deployment do
  delivery :ssh do
    use_sudo true
    roles app: '192.168.33.10'
    user "vagrant"
    password "vagrant"
  end
end
