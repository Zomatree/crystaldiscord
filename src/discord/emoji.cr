require "json"
require "./http"
require "../crystaldiscord"

class Crystaldiscord::Emoji
    @http : Crystaldiscord::HTTPClient
    property id : String | Nil
    property name : String
    property roles : Array(Crystaldiscord::Role)
    property user : Crystaldiscord::User?
    property require_colons : Bool
    property managed : Bool
    property animated : Bool
    property available : Bool

    def initialize(@http, @id, @name, @roles, @user, @require_colons, @managed, @animated, @available)
    end

    def Emoji.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"]?.try &.as_s
        name = data["name"].as_s
        roles = data["roles"].as_a.map do |role| Crystaldiscord::Role.from_json_object(role, http) end
        user = data["user"]?
        if user
            user = Crystaldiscord::User.from_json_object(user, http)
        end
        require_colons = data["require_colons"]? == true
        managed = data["managed"]? == true
        animated = data["animated"] == true
        available = data["available"] == true

        return Crystaldiscord::Emoji.new http, id, name, roles, user, require_colons, managed, animated, available
    end

end
