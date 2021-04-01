require "json"
require "../http"
require "../../crystaldiscord"

class Models::BaseUser
    @http : Crystaldiscord::HTTPClient
    property id : String
    property name : String
    property discriminator : String
    property avatar : String
    property bot : Bool
    property system : Bool
    property public_flags : Int64

    def initialize(@http, @id, @name, @discriminator, @bot, @avatar, @system, @public_flags)
    end

    def BaseUser.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"].as_s
        name = data["username"].as_s
        discriminator = data["discriminator"].as_s

        if bot = data["bot"]?
            bot = bot.as_bool
        else bot = false end

        avatar = data["avatar"].as_s
        
        if system = data["system"]?
            system = system.as_bool
        else system = false end
        
        if public_flags = data["public_flags"]?
            public_flags = public_flags.as_i64
        else public_flags = 0_i64 end
        
        return Models::BaseUser.new http, id, name, discriminator, bot, avatar, system, public_flags
    end
end


class Models::User < Models::BaseUser
    def BaseUser.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"].as_s
        name = data["username"].as_s
        discriminator = data["discriminator"].as_s

        if bot = data["bot"]?
            bot = bot.as_bool
        else bot = false end

        avatar = data["avatar"].as_s
        
        if system = data["system"]?
            system = system.as_bool
        else system = false end
        
        if public_flags = data["public_flags"]?
            public_flags = public_flags.as_i64
        else public_flags = 0_i64 end
        
        return Models::User.new http, id, name, discriminator, bot, avatar, system, public_flags
    end
end
