# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user)                   { create(:user) }
  let(:second_user)            { create(:user) }
  let(:question)               { create(:question, user:) }
  let(:reward)                 { create(:reward, question:, user:) }
  let(:reward_of_another_user) { create(:reward, question:, user: second_user) }

  describe 'GET #index' do
    before do
      login user
      get :index
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'shows that user has reward' do
      expect(assigns(:rewards)).to eq [reward]
    end

    it 'shows that user has not a reward' do
      expect(assigns(:rewards)).not_to eq [reward_of_another_user]
    end
  end
end
