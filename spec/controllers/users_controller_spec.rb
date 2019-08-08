require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'renders a new user template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let (:user_params) do
      { user: {
        username: 'jason',
        password: '654321'
        }
      }
    end

    context 'with valid params' do
      it 'redirects to the user show page' do
        post :create, params: user_params
        user = User.find_by(username: 'jason')
        expect(response).to redirect_to(user_url(user))
      end

      it 'logs the user in' do
        post :create, params: user_params
        user = User.find_by(username: 'jason')
        expect(session[:session_token]).to eq(user.session_token)
      end
    end

    context 'with invalid params' do
      it 'flashes an error' do
        post :create, params: { user: { username: "", password: '' } }
        expect(flash[:errors]).to be_present
      end

      it 'renders sign up page' do
        post :create, params: { user: { username: "", password: '' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
