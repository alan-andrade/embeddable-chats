require 'spec_helper'

describe Room do
  it 'should be open by default' do
    room = Room.new
    expect(room).to be_open
  end

  it 'belongs to a chat' do
    chat = stub_model(Chat)
    room = Room.new chat: chat
    expect(room.chat).to equal chat
  end

  it 'has a subject' do
    room = Room.new subject: 'guitars'
    expect(room.subject).to eq 'guitars'
  end

  it 'lets users to join' do
    room = Room.new
    dude = stub_model(User)
    room.join dude
    expect(room).to include(dude)
    expect(room.size).to eq 1
  end

  it 'kicks users out' do
    room = Room.new
    dude = stub_model(User)
    room.join dude
    room.kick dude
    expect(room).to be_empty
  end

  it 'wont join the user if the room is closed' do
    room = Room.new
    room.close
    expect(room).to be_closed
    expect {
      room.join double
    }.to raise_error(Room::ClosedError)
  end
end
