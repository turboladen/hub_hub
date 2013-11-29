module Rack
  class Snoop
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      body.each do |b|
        if headers['Content-Type'].match /json/i
          Rails.logger.debug "Response: #{b}"
        end
      end

      [status, headers, body]
    end
  end
end
