# Description
#   A hubot script that fetches images from Reddit's /r/aww frontpage
#
# Configuration:
#   None
#
# Commands:
#   hubot aww - Display the picture from /r/aww
#   hubot aww <number> - Display <number> of pictures from /r/aww
#
# Author:
#   eliperkins
#   Jeff Koenig <(none)>

url = require("url")

module.exports = (robot) ->
  robot.respond /aww((?: )[0-9]+)?/i, (msg) ->
    msg.http('https://www.reddit.com/r/aww.json')
      .get() (err, res, body) ->
        result = JSON.parse(body)

        count = msg.match[1] || "1"
        if count > 25 # reddit sends 25 per page
          count = 25
        urls = [ ]
        for child in result.data.children
          if child.data.domain != "self.aww"
            urls.push(child.data.url)

        if urls.count <= 0
          msg.send "Couldn't find anything cute..."
          return

        picked_urls = []
        for [1..count]
          rnd = Math.floor(Math.random()*urls.length)
          picked_url = urls.splice(rnd,1)[0]
          picked_urls.push(picked_url)

        for picked_url in picked_urls
          parsed_url = url.parse(picked_url)
          if parsed_url.host == "imgur.com"
            parsed_url.host = "i.imgur.com"
            parsed_url.pathname = parsed_url.pathname + ".jpg"
            picked_url = url.format(parsed_url)

          msg.send picked_url
