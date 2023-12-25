require "json"
require "./http"
require "../crystaldiscord"

class Crystaldiscord::Channel
  @http : Crystaldiscord::HTTPClient
  property id : String
  property name : String
  property type : Int32
  property topic : String
  property guild_id : String
  property nsfw : Bool
  property members : Array(Crystaldiscord::Member)

  def initialize(@http, @id, @name, @topic, @guild_id, @members)
  end

  def Channel.from_json_object(data : JSON::Any, http : Crystaldiscord::HTTPClient)
    id = data["id"].as_s
    type = data["type"].as_i32
    name = data["name"].as_s
    topic = data["topic"].as_s
    guild_id = data["guild_id"].as_s
    nsfw = data["nsfw"].as_b
    members = data["members"].as_a.map do |member|
      Crystaldiscord::Member.from_json_object(member, http)
    end
    return Channel.new http, id, type, name, topic, guild_id, nsfw, members
  end
end
