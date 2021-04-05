require "../crystaldiscord"
require "json"
require "./member"
require "time"

class Crystaldiscord::Message
    @http : Crystaldiscord::HTTPClient
    property id : String
    property channel_id : String
    property guild_id : String
    property author : Crystaldiscord::Member
    property content : String

    def initialize(@http, @id, @channel_id, @guild_id, @author, @content)
    end

    def Message.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        id = data["id"].as_s
        channel_id = data["channel_id"].as_s
        guild_id = data["guild_id"].as_s
       
        member = data["member"].as_h
        member["user"] = data["author"]

        user = Crystaldiscord::User.from_json_object(member["user"], http)
        nick = member["nick"]?.try &.as_s?
        roles = member["roles"].as_a.map do |role| role.as_s end
        joined_at = Time::Format::ISO_8601_DATE_TIME.parse member["joined_at"].as_s
        premium_since = Time::Format::ISO_8601_DATE_TIME.parse member["joined_at"].as_s
        deaf = member["deaf"]? == true
        mute = member["mute"]? == true
        pending = member["pending"]? == true
        permissions = member["permissions"]?
        if permissions.is_a?(Nil)
            permissions = "0"
        else
            permissions = permissions.as_s
        end

        author = Crystaldiscord::Member.new http, user, nick, roles, joined_at, premium_since, deaf, mute, pending, permissions

        content = data["content"].as_s

        return Crystaldiscord::Message.new http, id, channel_id, guild_id, author, content
    end
end
