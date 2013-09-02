require 'spec_helper'

describe Chat do
  it 'has an owner' do
    owner = double 'dude'
    chat = Chat.new owner: owner
    chat.owner.should eq owner
  end

  it 'has a unique identifier' do
    chat = Chat.new
    chat.id.should_not be_nil
  end

  it 'opens rooms' do
    chat = Chat.new
    chat.open_room
    chat.rooms.size.should == 1
  end

  it 'closes rooms' do
    chat = Chat.new
    room = chat.open_room
    room.should_receive(:close)
    chat.close_room room
  end
end
