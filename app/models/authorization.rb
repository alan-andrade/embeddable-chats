class Authorization < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_from_auth_hash hash
    where{
      (provider == my{ hash.provider }) &&
      (uid == my{ hash.uid })
    }.first
  end

  def self.create_from_auth_hash hash
    user ||= User.create_from_auth_hash hash
    user.authorizations.create provider: hash.provider, uid: hash.uid
  end
end
