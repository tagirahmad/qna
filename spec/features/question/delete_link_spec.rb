# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links to question' do
 	given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/tagirahmad/62598000f63a19949cbfeb39793a3c29' }
  given(:gist_url2) { 'https://google.com' }
  given(:question) { create :question, user: user  }

  before { login user  }

  scenario 'User deletes links when asks question', js: true do

  end

end

