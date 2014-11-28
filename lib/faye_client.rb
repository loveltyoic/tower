require 'net/http'

class FayeClient
  FAYE_CONFIG = YAML.load_file(File.expand_path("../../config/faye.yml", __FILE__))['development']

  def self.publish(channel, data)
    # post(FAYE_CONFIG["faye_server"], {
    #   message: {
    #     channel: channel, 
    #     data: data.merge(token: FAYE_CONFIG["faye_token"])
    #   }
    # })

    data[:token] = FAYE_CONFIG["faye_token"]
    message = {channel: channel, data: data}
    uri = URI.parse(FAYE_CONFIG["faye_server"])
    Net::HTTP.post_form(uri, message: message.to_json)

  end
end