# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  FactoryBot.build(:user)

  subject(:user) { User.new(username: "harry", password: "123456")}

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
  
    it { should validate_uniqueness_of(:session_token) }

    it { should validate_length_of(:password).is_at_least(6) }
  end
end

describe '#ensure_session_token' do
  it 'ensures that a session token is set upon initialize' do
    user = FactoryBot.create(:user)
    expect(user.session_token).to_not be_nil
  end
end


describe '::find_by_credentials' do
  #create vs build
  user = FactoryBot.create(:user, password: '123456')
  it 'should return the correct user' do
    expect(User.find_by_credentials(user.username, user.password)).to eq(user)
  end
  
  it 'should return nil if the credentials are wrong' do
    expect(User.find_by_credentials(user.username, '123457')).to be_nil
    expect(User.find_by_credentials('not_a_harry_potter_character', user.password)).to be_nil
  end
end
