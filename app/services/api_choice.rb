# frozen_string_literal: true

require 'net/http'

class ApiChoice
  RPS_API_URL = 'https://5eddt4q9dk.execute-api.us-east-1.amazonaws.com/rps-stage/throw'
  RPS_MOCK_URL = 'https://private-anon-4b42eef306-curbrockpaperscissors.apiary-mock.com/rps-stage/throw'

  def call
    return unless success?

    JSON.parse(response.body)['body'].to_sym
  end

  def success?
    response&.is_a?(Net::HTTPSuccess)
  end

  private

  def response
    @response ||=
      begin
        Net::HTTP.get_response(uri)
      rescue SocketError, Net::HTTPError => e
        Rails.logger.error("Error calling `#{uri}`: #{e}")
        false
      end
  end

  def uri
    URI(api_url)
  end

  # requesting production API url always returns 500
  # mock API url returns always success result and throws `rock`
  def api_url
    [RPS_API_URL, RPS_MOCK_URL].sample
  end
end
