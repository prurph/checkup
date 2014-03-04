ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'simplecov'

SimpleCov.start

Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

FactoryGirl.lint # Make sure the default values for all our factories are valid

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
  config.include FactoryGirl::Syntax::Methods
  config.include SessionHelpers
  config.order = 'random'
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
