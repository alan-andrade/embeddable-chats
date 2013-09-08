require 'spec_helper'

describe Message do
  let(:room) { stub_model Room }

  it 'belongs to a room' do
    message = Message.new room: room
    expect(message.room).to equal room
  end

  it 'has a body' do
    message = Message.new body: 'im the body'
    expect(message.body).to eq 'im the body'
  end

  it 'has a sender' do
    sender = stub_model(User)
    message = Message.new sender: sender
    expect(message.sender).to equal sender
  end
end
