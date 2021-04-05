require "time"
require "json"
require "../crystaldiscord"
require "./user"
class Crystaldiscord::Member
    @http : Crystaldiscord::HTTPClient
    property user : Crystaldiscord::BaseUser
    property nick : String | Nil
    property roles : Array(String)
    property joined_at : Time?
    property premium_since : Time?
    property deaf : Bool
    property mute : Bool
    property pending : Bool
    property permissions : String

    def initialize(@http, @user, @nick, @roles, @joined_at, @premium_since, @deaf, @mute, @pending, @permissions)
    end

    def Member.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
        user = Crystaldiscord::User.from_json_object(data["user"], http)
        nick = data["nick"]?.try &.as_s?
        roles = data["roles"].as_a.map do |role| role.as_s end
        joined_at = Time::Format::ISO_8601_DATE_TIME.parse data["joined_at"].as_s
        premium_since = Time::Format::ISO_8601_DATE_TIME.parse data["joined_at"].as_s
        deaf = data["deaf"]? == true
        mute = data["mute"]? == true
        pending = data["pending"]? == true
        permissions = data["permissions"]?
        if permissions.is_a?(Nil)
            permissions = "0"
        else
            permissions = permissions.as_s
        end

        return Crystaldiscord::Member.new http, user, nick, roles, joined_at, premium_since, deaf, mute, pending, permissions
    end
end
