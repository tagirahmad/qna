# OmniAuth.config.allowed_request_methods = %i[get post]
# OmniAuth.config.allowed_request_methods = %i[post get]
OmniAuth.config.allowed_request_methods = %i[post]

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :github,
#            Rails.application.credentials[Rails.env.to_sym][:github][:app_id],
#            Rails.application.credentials[Rails.env.to_sym][:github][:app_secret],
#            scope: 'user:email, read:user'
#
#   provider :google_oauth2,
#            Rails.application.credentials[Rails.env.to_sym][:google_oauth2][:app_id],
#            Rails.application.credentials[Rails.env.to_sym][:google_oauth2][:app_secret]
# end
