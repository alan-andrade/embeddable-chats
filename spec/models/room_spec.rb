require 'spec_helper'

describe Room do
  it 'should be open by default' do
    room = Room.new
    room.should be_open
  end

  it 'belongs to a chat' do
    chat = double
    room = Room.new chat: chat
    room.chat.should == chat
  end

  it 'has a subject' do
    room = Room.new subject: 'guitars'
    room.subject.should == 'guitars'
  end

  it 'lets users to join' do
    room = Room.new
    dude = double 'dude'
    room.join dude
    room.participants.should include(dude)
    room.participants.size.should == 1
  end

  it 'kicks users out' do
    room = Room.new
    dude = double 'dude'
    room.join dude
    room.kick dude
    room.participants.should be_empty
  end

  it 'wont join the user if the room is closed' do
    room = Room.new
    room.close
    room.should be_closed
    expect {
      room.join double
    }.to raise_error(Room::ClosedError)
  end
end
