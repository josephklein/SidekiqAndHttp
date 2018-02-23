require 'sidekiq'
require_relative 'http_connection'
Sidekiq::Logging.logger = nil

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    # For exercise 3, replace this comment with code that
    # sends the request, parses the response, and uses `puts` to
    # print the message part of the response
    response_obj = HttpConnection.get(path, query: params)

    # For exercise 5, replace this comment with code that
    # retries the request if it fails

    4.times do
      if response_obj.response.code == "200"
        break
      end
      sleep 2
      response_obj = HttpConnection.get(path, query: params)
    end

    puts JSON.parse(response_obj.body)["message"]
  end

end
