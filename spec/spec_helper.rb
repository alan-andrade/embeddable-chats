# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/factories/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = true
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
end

OmniAuth.config.test_mode = true

FactoryGirl.define do
  sequence(:email){ |n| "user#{n}@test.com" }
end

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Using the plataformatec hack to handle js tests with sqlite3.
# Dbcleaner is having problems cleaning sqlite3 tables right now,
# when we switch to a better database, this might need to go.
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
