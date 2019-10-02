class JwtSessionWrapper
  def self.create_session(user)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login
    response_cookie(response, tokens)
    render json: { csrf: tokens[:csrf] }
  end

  def self.refresh_session
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload
    response_cookie(response, tokens)
    render json: { csrf: tokens[:csrf] }
  end

  def self.end_session
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def response_cookie(response, tokens)
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
  end
end
