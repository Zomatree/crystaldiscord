require "json"
require "../http"
require "../../crystaldiscord"

class Models::RoleTag
    property bot_id : String?
    property intergration_id : String?
    property premium_subscriber : Bool

    def initialize(@bot_id, @intergration_id, @premium_subscriber)
    end

    def RoleTag.from_json_object(data : JSON::Any)
        if bot_id = data["bot_id"]?
            bot_id = bot_id.as_s
        else bot_id = nil end

        if intergration_id = data["bot_id"]?
            intergration_id = intergration_id.as_s
        else intergration_id = nil end

        premium_subscriber = data["premium_subscriber"]?
        if premium_subscriber
            premium_subscriber = true
        else
            premium_subscriber = false
        end

        return RoleTag.new bot_id, intergration_id, premium_subscriber
    end
end

class Models::Role
    @http : Crystaldiscord::HTTPClient
    @id : String
    @name : String
    @color : Int32
    @hoist : Bool
    @position : Int32
    @permissions : Int32
    @managed : Bool
    @mentionable : Bool
    @tags : Array(Models::RoleTag)

    def initialize(@http, @id, @name, @color, @hoist, @position, @permissions, @managed, @mentionable, @tags)
    end

    def Role.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"].as_s
        name = data["name"].as_s
        color = data["color"].as_i
        hoist = data["hoist"].as_bool
        position = data["position"].as_i
        permissions = data["permissions"].as_i
        managed = data["managed"].as_bool
        mentionable = data["mentionable"].as_bool
        tags = data["tags"]?
        if !tags.is_a?(Array)
            tags = [] of JSON::Any
        end
        tags = tags.map do |role| Models::RoleTag.from_json_object(role) end
        
        return Role.new http, id, name, color, hoist, position, permissions, managed, mentionable, tags
    end

end
