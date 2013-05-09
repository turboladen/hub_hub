hosts = {
  'chat.mindhub.org' => {
    user: 'deploy',
    host_alias: :chat
  },
}
cmd_history = 'cmd_history.yml'

Screenplay.sketch(hosts, cmd_history_file: cmd_history) do |host|
  postfix_aliases_dest = '/etc/aliases'
  postfix_aliases_source = File.expand_path(File.dirname(__FILE__) + '/config/screenplay/templates/etc_aliases')

  host.shell.su do
    host.shell.exec 'gem install bundler'
    host.file postfix_aliases_dest, owner: 'root', group: 'root', mode: '644',
      contents: lambda { |file|
        file.from_template(postfix_aliases_source)
      }
    host.shell.exec 'newaliases'
    host.packages.upgrade_packages
  end
end

puts 'Done sketching'
