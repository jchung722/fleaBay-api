class JwtSessionWrapper
  include JWTSessions::RailsAuthorization
  class << self
    def create_session(user, response)
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      response_cookie(response, tokens)
      tokens
    end

    def refresh_session(response, claimless_payload)
      session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
      tokens = session.refresh_by_access_payload
      response_cookie(response, tokens)
      tokens
    end

    def end_session(payload)
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      session.flush_by_access_payload
    end

    private

    def response_cookie(response, tokens)
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
    end
  end
end
