require 'spec_helper'

describe User do
  it 'should create a chat right after creation' do
    u = User.create email: 'foo@bar.com'
    u.chat.should_not be_nil
  end
end
