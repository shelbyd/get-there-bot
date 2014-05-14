require 'net/irc'

log = Logger.new(STDOUT)

class Client < Net::IRC::Client
  def on_rpl_welcome(m)
    ENV['CHANNELS'].split(' ').each do |channel|
      post JOIN, "##{channel}"
    end
  end

  def on_privmsg(m)
    return unless m[1][0] == '!'
    begin
      channel = m[0]
      command = CommandParser.parse(m[1])
      if command.action == :calculate_outs
        result = OutCalculator.evaluate(command)
        out_message = PercentagePresenter.present(result)
        post PRIVMSG, channel, out_message
      end
    rescue InvalidCommandException
      post PRIVMSG, channel, "invalid command '#{m[1]}'"
    rescue => e
      log.fatal("Caught unknown exception")
      log.fatal(e)
    end
  end
end

