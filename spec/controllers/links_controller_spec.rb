# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user)        { create :user }
  let(:second_user) { create :user }

  let!(:question)   { create :question, user: user }
  let!(:link)       { create :link, linkable: question }

  let(:delete_link) { delete :destroy, params: { id: link }, format: :js }

  describe 'DELETE #destroy' do
    context 'Authorized user delete link' do
      before { login user }

      it 'delete link' do
        expect { delete_link }.to change(question.links, :count).by(-1)
      end

      it 'renders show view' do
        delete_link
      end
    end

    context 'Authorized user tries to delete link' do
      before { login second_user }

      it 'user tries to delete not his link' do
        expect { delete_link }.not_to change(question.links, :count)
      end

      it 'renders show view' do
        delete_link
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete link' do
        expect { delete_link }.not_to change(question.links, :count)
      end

      it 'show error message' do
        delete_link
        expect(response.body).to have_content 'You need to sign in or sign up before continuing'
      end
    end
  end
end
