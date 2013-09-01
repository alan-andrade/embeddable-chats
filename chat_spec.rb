# Chat modeling.
#
# A user can create a chat instance.
#
# The chat instance has a unique identifier.
# The user is the owner of that instance.
#   - he can delete it.
#   - embed it.
#   - kick users.
# Participants can request collective user banning.

require 'securerandom'

class Chat
  attr_reader :owner, :id

  def initialize options={}
    @id = SecureRandom.urlsafe_base64
    @owner = options[:owner]
  end

  def open_room
    r = Room.new
    rooms << r
    r
  end

  def close_room room
    if rooms.include? room
      room.close
    end
  end

  def rooms
    @rooms ||= []
  end
end

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

class Room
  class ClosedError < StandardError
    def initialize
      @message = "Tried to join a participant while closed"
    end
  end

  attr_reader :subject, :chat

  def initialize attributes={}
    @open = true
    @subject = attributes[:subject]
    @chat = attributes[:chat]
  end

  def open?
    @open
  end

  def join user
    if closed?
      raise ClosedError
    end
    participants << user
  end

  def kick user
    participants.delete user
  end

  def participants
    @participants ||= []
  end

  def close
    @open = false
  end

  def closed?
    !@open
  end

end

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

class Message
  attr_reader :room, :body, :sender

  def initialize attributes={}
    @room = attributes[:room]
    @body = attributes[:body]
    @sender = attributes[:sender]
  end
end

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
