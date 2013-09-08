require 'spec_helper'

describe User do
  subject(:user) { User.create email: 'foo@bar.com' }

  it 'creates a chat right after user creation' do
    expect(user.chat).not_to be_nil
  end
end
