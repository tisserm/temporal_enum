# frozen_string_literal: true

require "temporal_enum"
require "with_model"
require "active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
  end

  config.extend WithModel
end
