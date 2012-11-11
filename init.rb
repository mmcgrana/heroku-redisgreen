require "heroku/command/base"
require "heroku/helpers"

class Heroku::Command::Sightglass < Heroku::Command::Base

  # sightglass:logs
  #
  # display logs for an app
  def logs
    url = "#{sightglass_url}/logs"
    logs = Heroku::Helpers.json_decode(RestClient.get(url))
    logs.each do |log|
      puts(log)
    end
  end

  def sightglass_url
    config = api.get_config_vars(app).body
    if url = config["SIGHTGLASS_URL"]
      url
    else
      error("Sightglass is not installed on this app.\nInstall it with `heroku addons:add sightglass -a #{app}`.")
    end
  end
end
