class Room < ActiveRecord::Base
  class ClosedError < StandardError
    def initialize
      @message = "Tried to join a participant while closed"
    end
  end

  belongs_to :chat
  has_many :room_participations
  has_many :users, through: :room_participations
  has_many :messages

  delegate :include?, :size, :empty?, to: :users

  def join user
    if closed?
      raise ClosedError
    end
    users << user
  end

  def kick user
    users.destroy user
  end

  def close
    update_attributes is_open: false
  end

  def closed?
    !is_open?
  end

  def open?
    is_open?
  end

end
