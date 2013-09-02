class Message
  attr_reader :room, :body, :sender

  def initialize attributes={}
    @room = attributes[:room]
    @body = attributes[:body]
    @sender = attributes[:sender]
  end
end

