class User < ActiveRecord::Base
  has_many :room_participations
  has_many :rooms, through: :room_participations
  has_many :authorizations
  has_one :chat, foreign_key: :owner_id

  after_create do
    create_chat
  end

  def self.create_from_auth_hash auth_hash
    create email: auth_hash.info.email
  end
end
