require "heroku/command/base"
require "heroku/helpers"

class Heroku::Command::Redisgreen < Heroku::Command::Base

  # redisgreen:cli
  #
  # open a redis-cli session for the database
  #
  #Example (interactive CLI):
  #
  # $ heroku redisgreen:cli -a my-app
  # redis smart-dandelion-4.redisgreen.net:11035>
  #
  #Example (single-command mode):
  #
  # $ heroku redisgreen:cli -a my-app SET mykey "hello world"
  # OK
  # $ heroku redisgreen:cli -a my-app GET mykey
  # "hello world"
  #
  def cli
    url = extract_url
    uri = URI.parse(url)
    begin
      exec("redis-cli", "-a", uri.password, "-h", uri.host, "-p", uri.port.to_s, *args)
    rescue Errno::ENOENT
      error("The redis-cli command is not available - please install it and try again.")
    end
  end

  private

  def extract_url
    config = api.get_config_vars(app).body
    if url = config["REDISGREEN_URL"]
      url
    else
      error("RedisGreen is not installed on this app.\nInstall it with `heroku addons:add redisgreen -a #{app}`.")
    end
  end
end
