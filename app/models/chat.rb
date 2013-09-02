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
