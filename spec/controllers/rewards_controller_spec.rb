# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user)                { create :user }
  let(:question)            { create :question, user: user }
  let(:reward)              { create :reward, question: question, user: user }
  let(:reward_without_user) { create :reward, question: question }

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
    
    it 'user has not a reward' do
      expect(assigns(:rewards)).not_to eq [reward_without_user]
    end

  end
end
