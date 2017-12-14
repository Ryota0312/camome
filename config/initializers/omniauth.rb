Rails.application.config.middleware.use OmniAuth::Builder do
  require '/camome/lib/google_oauth2_calendar.rb'
  provider :google_oauth2,
                  ApplicationSettings.oauth.google.application_id,
                  ApplicationSettings.oauth.google.application_secret,
                  prompt: "consent",
                  skip_jwt: true
  
  provider :google_oauth2_calendar,
                  ApplicationSettings.oauth.google_calendar.application_id,
                  ApplicationSettings.oauth.google_calendar.application_secret,
                  scope: "calendar profile",
                  prompt: "consent",
                  skip_jwt: true
end
