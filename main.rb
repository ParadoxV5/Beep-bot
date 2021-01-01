# frozen_string_literal: true
require('csv')
require('discordrb')

DATA_PATH = File.expand_path("#{__FILE__}/../map.csv")
def load_data
  data = {}
  CSV.foreach(DATA_PATH) do|replace_with, *regexps|
    next unless replace_with
    regexps.each do|regexp| data[Regexp.new(regexp, true)] = replace_with end
  end
  $data = data
end

load_data
begin
  require 'listen'
  Listen.to("#{__FILE__}/../") do|modified_files|
    load_data if modified_files.any?(DATA_PATH)
  end.start
rescue LoadError
  warn('`listen` gem not found. You’ll have to restart Beep bot to manually reload `map.csv`.')
end

BOT = Discordrb::Bot.new(token: File.open("#{__FILE__}/../bot_token.txt", &:gets))
at_exit do BOT.stop end

BOT.message do|event|
  $text = event.text.dup
  unless ($catches = $data.filter do|regexp, replace_with| $text.gsub!(regexp, replace_with) end).empty?
    $event_message = event.message
    $event_message.respond(
      '> <@' + event.user.id.to_s + '>' + if $event_message.attachments.empty?
        "\r\n"
      else
        "\t(File `" + $event_message.attachments.first.filename + "` has been lost in Discord.)\r\n"
      end,
      false, nil, nil, nil,
      $event_message.referenced_message
    )
    $event_message.respond($text)
    $event_message.delete('Beep bot triggered: ' + $catches.keys.join(' ')) # Join regexps with single space, ignore replace_with
  end
end

begin
  BOT.run
rescue Interrupt
end