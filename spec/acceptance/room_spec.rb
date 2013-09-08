require 'spec_helper'

feature 'Messaging in chat rooms' do
  given(:user) { create :user }
  given!(:room) { user.chat.rooms.create subject: 'Dogs' }

  background { login user }

  it 'posts a new message' do
    visit room_path room
    expect(current_path).to eq '/rooms/1'

    fill_in :message_body, with: 'I like dogs'
    click_button 'Send'

    expect(page.body).to match 'I like dogs'
  end

end

def login user
  OmniAuth.config.mock_auth[:facebook] =
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 1234,
        info: OmniAuth::AuthHash::InfoHash.new(email: user.email))

  visit '/'
  click_link 'Sign Up with FB'
end
