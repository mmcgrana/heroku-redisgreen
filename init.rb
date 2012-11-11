require "heroku/command/base"

class Heroku::Command::Sightglass < Heroku::Command::Base

  # sightglass:logs
  #
  # display logs for an app
  def logs
    config = api.get_config_vars(app).body
    if url = config["SIGHTGLASS_URL"]
      puts(url)
    else
      error("Sightglass is not installed on this app.\nInstall it with `heroku addons:add sightglass -a #{app}`.")
    end
  end
end
