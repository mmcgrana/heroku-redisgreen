require "heroku/command/base"

class Heroku::Command::Sightglass < Heroku::Command::Base
  
  # sightglass:logs
  def logs
    puts("logs logs logs!")
  end
end
