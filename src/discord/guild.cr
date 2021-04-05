require "json"
require "./http"
require "../crystaldiscord"

class Crystaldiscord::Guild
    @http : Crystaldiscord::HTTPClient
    property id : String
    property name : String
    property owner_id : String
    property roles : Array(Crystaldiscord::Role)
    property emojis : Array(Crystaldiscord::Emoji)
    property members : Array(Crystaldiscord::Member)

    def initialize(@http, @id, @name, @owner_id, @roles, @emojis, @members)
    end

    def Guild.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"].as_s
        name = data["name"].as_s
        owner_id = data["owner_id"].as_s
        roles = data["roles"].as_a.map do |role| Crystaldiscord::Role.from_json_object(role, http) end
        emojis = data["emojis"].as_a.map do |emoji| Crystaldiscord::Emoji.from_json_object(emoji, http) end
        members = data["members"].as_a.map do |member| Crystaldiscord::Member.from_json_object(member, http) end
        return Guild.new http, id, name, owner_id, roles, emojis, members
    end
end
