require "json"
require "../http"
require "../models"
require "../../crystaldiscord"

class Models::Emoji
    @http : Crystaldiscord::HTTPClient
    property id : String | Nil
    property name : String
    property roles : Array(Models::Role)
    property user : Models::User?
    property require_colons : Bool
    property managed : Bool
    property animated : Bool
    property available : Bool

    def initialize(@http, @id, @name, @roles, @user, @require_colons, @managed, @animated, @available)
    end

    def Emoji.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"]?.try &.as_s
        name = data["name"].as_s
        roles = data["roles"].as_a.map do |role| Models::Role.from_json_object(role, http) end
        user = data["user"]?
        if user
            user = Models::User.from_json_object(user, http)
        end
        require_colons = data["require_colons"]? == true
        managed = data["managed"]? == true
        animated = data["animated"] == true
        available = data["available"] == true

        return Models::Emoji.new http, id, name, roles, user, require_colons, managed, animated, available
    end

end
