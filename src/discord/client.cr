require "./dispatcher"
require "./http"
require "./models"
require "http"
require "json"
require "fiber"


class Crystaldiscord::Client
    property token : String
    property dispatcher : Dispatcher
    property ws : HTTP::WebSocket | Nil
    property http : HTTPClient
    property guild_cache = {} of String => Models::Guild
    property unready_guilds : Set(String) = Set.new [] of String
    property session_id = ""
    property last_d : String | Nil
    property user : Models::BaseUser | Nil

    def initialize(token)
        @token = "Bot #{token}"
        @dispatcher = Dispatcher.new
        @http = HTTPClient.new @token
        @user = nil
        @last_d = nil
    end

    def send_ws(msg)
        if ws = @ws
            ws.send msg
        end
    end

    def handle_ws(msg : String)
        msg = JSON.parse(msg)
        op = msg["op"].as_i
        case op
        when 10
            sleep_time = msg["d"]["heartbeat_interval"].as_i / 1000
            spawn do
                identify = JSON.build do |json|
                    json.object do
                        json.field "op", 2
                        json.field "d", do json.object do
                            json.field "token", @token
                            json.field "intents", 32509  # ill do this later - all but privilaged
                            json.field "properties", do json.object do
                                json.field "$os", "linux"
                                json.field "$browser", "crystaldiscord"
                                json.field "$device", "crystaldiscord"
                            end
                            end
                        end
                        end
                    end
                end

                self.send_ws(identify)

                loop do
                    sleep(sleep_time)
                    self.send_ws({"op" => 1, "d" => @last_d}.to_json)
                end
            end

        when 0
            event = msg["t"].as_s
            puts event
            case event
            when "READY"
                @user = Models::BaseUser.from_json_object msg["d"]["user"], @http
                @unready_guilds = Set.new(msg["d"]["guilds"].as_a.map do |guild| guild["id"].as_s end)
            when "GUILD_CREATE"
                guild = Models::Guild.from_json_object(msg["d"], @http)
                @unready_guilds.delete(guild.id)

            end
        end
    end

    def run()
        ws_url = @http.get_gateway["url"].as_s
        @ws = ws = HTTP::WebSocket.new "#{ws_url}/v=8&encoding=json"
        
        ws.on_close do |code, msg|
            puts "#{code}: #{msg}"
        end
        
        ws.on_message { |msg| 
            spawn do
                self.handle_ws msg
            end
        }

        ws.run
    end

    def event(name : String, &block : PROC)
        @dispatcher.register name, block
    end
end
