require "spec"
require "../src/crystaldiscord"
require "file"

token = File.read "token"

client = Crystaldiscord::Client.new token.strip
client.on_message = ->(msg : Crystaldiscord::Message) {
    puts "#{msg.author.user.name} #{msg.content}"
}

client.run()
