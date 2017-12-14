require 'omniauth-google-oauth2'
module OmniAuth
  module Strategies
    class GoogleOauth2Calendar < OmniAuth::Strategies::GoogleOauth2
      option :name, 'google_oauth2_calendar'
    end
  end
end
