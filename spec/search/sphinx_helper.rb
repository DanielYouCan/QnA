require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:each) do
    # Default to transaction strategy for all specs
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :sphinx => true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
