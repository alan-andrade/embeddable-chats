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
