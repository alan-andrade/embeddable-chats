require 'spec_helper'

describe Chat do
  it 'has an owner' do
    owner = stub_model(User)
    chat = Chat.new owner: owner
    expect(chat.owner).to equal owner
  end

  it 'has a unique identifier' do
    chat = Chat.new
    chat.save
    expect(chat.id).not_to be_nil
  end

  it 'opens rooms' do
    chat = Chat.new
    chat.open_room
    expect(chat.rooms.size).to eq 1
  end

  it 'closes rooms' do
    chat = Chat.new
    room = chat.open_room
    room.should_receive(:close)
    chat.close_room room
  end
end
