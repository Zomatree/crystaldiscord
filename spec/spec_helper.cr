require "spec"
require "../src/crystaldiscord"
require "file"

token = File.read "token"

client = Crystaldiscord::Client.new token.strip

client.run
