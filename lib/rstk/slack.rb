require "json"
require "net/http"
require "uri"

module Rstk
  class Slack
    def self.send(text)
      data = {
        "text" => text,
        "username"   => "rstk",
        "icon_emoji" => ":imp:",
        "link_names" => 1,
      }
      request_url = IO.readlines("slack.url")[0]
      uri = URI.parse(request_url)
      Net::HTTP.post_form(uri, {"payload" => data.to_json})
    end
  end
end
