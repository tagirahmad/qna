FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'http://0.0.0.0:3000/' }
    uid { '12345678' }
    secret { '87654321' }
  end
end
