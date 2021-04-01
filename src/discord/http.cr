require "http/client"
require "json"
require "openssl"

enum Crystaldiscord::RequestType
    Get
    Post
    Patch
    Delete
end

class Crystaldiscord::Route
    @url : String
    @body : JSON
    @headers = {} of String => String
    def initialize(@url, @body, @headers) end
end

class Crystaldiscord::HTTPClient
    @@base_url = "https://discord.com/api/v8"
    @token : String
    @tls_context = OpenSSL::SSL::Context::Client.new

    def initialize(@token) end

    def request(type : Crystaldiscord::RequestType, url : String,  body : String)
        headers = HTTP::Headers{"Authorization" => @token, "User-Agent" => "DiscordBot (private, 0.1)"}
        
        case type  # this will have all of them but im lazy and dont need them yet
        when Crystaldiscord::RequestType::Get
            resp = HTTP::Client.get("#{@@base_url}#{url}", headers: headers, tls: @tls_context)
        end

        if !resp.nil?
            return JSON.parse resp.body
        else
            return JSON.parse "{}"
        end
    end

    def request(type : Crystaldiscord::RequestType, url : String)
        self.request(type, url, "")
    end

    def get_gateway()
        return self.request Crystaldiscord::RequestType::Get, "/gateway/bot"
    end
end
