require 'spec_helper'

feature 'Chat rooms' do
  given(:user) { create :user }
  given!(:room) { user.chat.rooms.create subject: 'Dogs' }

  scenario 'require users to sign it first' do
    visit room_path room
    expect(current_path).to eq '/'
  end

  context 'signed in users' do
    background { login user }

    scenario 'will join the chat room automatically' do
      expect(room.users).to have(0).item
      visit room_path room
      expect(room.users).to have(1).item
    end

    scenario 'are able to post new messages' do
      visit room_path room
      expect(current_path).to eq '/rooms/1'

      fill_in :message_body, with: 'I like dogs'
      click_button 'Send'

      expect(page.body).to match 'I like dogs'
    end

    scenario 'can read a live stream of messages', js: true do
      visit room_path room
      room.messages.create body: 'live message'
      Timecop.travel Time.now + 5.seconds do
        expect(page.body).to match 'live message'
      end
    end
  end

end
