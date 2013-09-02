class Chat < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :rooms

  def open_room
    save unless persisted?
    room = rooms.create
    room
  end

  def close_room room
    if rooms.include? room
      room.close
    end
  end

end
