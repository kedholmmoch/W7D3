require 'rails_helper'


RSpec.describe SessionsController, type: :controller do

  describe 'GET #new' do
    it 'render the signin page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do

    user1 = FactoryBot.create(:user)

    let (:user_params) do
      { user: {
        username: user1.username,
        password: user1.password
      } }
    end
    context 'with valid params' do
      it 'redirects to the user show page' do
        post :create, params: user_params
        user = User.find_by(username: user1.username )
        expect(response).to redirect_to(user_url(user))
      end

      it 'logs the user in' do
        post :create, params: user_params
        user = User.find_by(username: user1.username)
        expect(session[:session_token]).to eq(user.session_token)
      end
    end

    context 'with invalid params' do
      it 'flashes an error' do
        post :create, params: { user: { username: "", password: '654321' } }
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do


    it 'logs out user' do

      user1 = FactoryBot.create(:user)
      session[:session_token] = user1.session_token
      delete :destroy
      user = User.find_by(username: user1.username)
      expect(session[:session_token]).to_not eq(user.session_token)
    end

    it 'redirects user to signin page' do

      user1 = FactoryBot.create(:user)
      session[:session_token] = user1.session_token
      delete :destroy
      user = User.find_by(username: user1.username)
      expect(response).to redirect_to(new_session_url)
    end
  end

end
