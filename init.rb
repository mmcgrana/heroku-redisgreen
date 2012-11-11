require "heroku/command/base"
require "heroku/helpers"

class Heroku::Command::Sightglass < Heroku::Command::Base

  # sightglass:logs
  #
  # display logs for an app
  #
  # -t, --tail # continually stream logs
  #
  #Example:
  #
  # $ heroku sightglass:logs
  # 2012-01-01T12:00:00+00:00 heroku[api]: Config add EXAMPLE by email@example.com
  # 2012-01-01T12:00:01+00:00 heroku[api]: Release v1 created by email@example.com
  #
  def logs
    validate_arguments!
    url = "#{extract_url}/logs"
    if options[:tail]
      url << "?tail=1"
    end
    begin
      read_logs(url) do |log|
        display("#{log["timestamp"]} #{log["source"]}[#{log["process"]}]: #{log["message"]}")
      end
    rescue Errno::EPIPE
    end
  end

  private

  def read_logs(url)
    uri  = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    get = Net::HTTP::Get.new(uri.path + (uri.query ? "?" + uri.query : ""))
    get.basic_auth uri.user, uri.password
    if uri.scheme == "https"
      http.use_ssl = true
      if ENV["HEROKU_SSL_VERIFY"] == "disable"
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end
    http.read_timeout = 60 * 60
    begin
      http.start do
        http.request(get) do |request|
          request.read_body do |chunk|
            chunk = chunk.strip
            if chunk != ""
              chunk.split("\n").each do |line|
                log = Heroku::Helpers.json_decode(line)
                yield(log)
              end
            end
          end
        end
      end
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError
      error("Could not connect to Sightglass")
    rescue Timeout::Error, EOFError
      error("\nRequest timed out")
    end
  end

  def extract_url
    config = api.get_config_vars(app).body
    if url = config["SIGHTGLASS_URL"]
      url
    else
      error("Sightglass is not installed on this app.\nInstall it with `heroku addons:add sightglass -a #{app}`.")
    end
  end
end
