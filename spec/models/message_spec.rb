require 'spec_helper'

describe Message do
  let(:room) { double 'room' }

  it 'belongs to a room' do
    message = Message.new room: room
    message.room.should == room
  end

  it 'has a body' do
    message = Message.new body: 'im the body'
    message.body.should == 'im the body'
  end

  it 'has a sender' do
    sender = double 'dude'
    message = Message.new sender: sender
    message.sender.should == sender
  end
end
