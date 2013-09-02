class User < ActiveRecord::Base
  has_many :room_participations
  has_many :rooms, through: :room_participations
end
