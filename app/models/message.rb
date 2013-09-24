class Message < ActiveRecord::Base
  belongs_to :room
  belongs_to :sender, class_name: 'User'

  scope :recent, -> {
    where{ created_at >= Time.now - 5.hours }
  }
end

