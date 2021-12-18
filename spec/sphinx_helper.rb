# frozen_string_literal: true

require 'rails_helper'

# module SphinxHelpers
#   def index
#     ThinkingSphinx::Test.index
#     # Wait for Sphinx to finish loading in the new index files.
#     sleep 0.25 until index_finished?
#   end
#
#   def index_finished?
#     Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
#   end
# end
#
# RSpec.configure do |config|
#   config.include SphinxHelpers, type: :feature
#   config.use_transactional_fixtures = false
#
#   config.before(:suite) do
#     DatabaseCleaner.strategy = :transaction
#     # Ensure sphinx directories exist for the test environment
#     ThinkingSphinx::Test.init
#     # Configure and start Sphinx, and automatically
#     # stop Sphinx at the end of the test suite.
#     ThinkingSphinx::Test.start_with_autostop
#   end
#
#   config.before(:each) do
#     # Index data when running an acceptance spec.
#     index if example.metadata[:sphinx]
#   end
#
#   config.before(:each, :sphinx => true) do
#     # For tests tagged with Sphinx, use deletion (or truncation)
#     DatabaseCleaner.strategy = :deletion
#   end
#
#   config.before do
#     DatabaseCleaner.start
#   end
#
#   config.append_after do
#     DatabaseCleaner.clean
#   end
# end

# RSpec.configure do |config|
#   # Transactional fixtures work with real-time indices
#   config.use_transactional_fixtures = true
#
#   config.before :each do |example|
#     # Configure and start Sphinx for request specs
#     if example.metadata[:type] == :feature
#       ThinkingSphinx::Test.init
#       ThinkingSphinx::Test.start index: false
#     end
#
#     # Disable real-time callbacks if Sphinx isn't running
#     ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
#       (example.metadata[:type] == :feature)
#   end
#
#   config.after(:each) do |example|
#     # Stop Sphinx and clear out data after request specs
#     if example.metadata[:type] == :feature
#       ThinkingSphinx::Test.stop
#       ThinkingSphinx::Test.clear
#     end
#   end
# end
#

# RSpec.configure do |config|
#   config.use_transactional_fixtures = false
#
#   config.before(:each) do
#     # Default to transaction strategy for all specs
#     DatabaseCleaner.strategy = :transaction
#   end
#
#   config.before(:each, :sphinx => true) do
#     # For tests tagged with Sphinx, use deletion (or truncation)
#     DatabaseCleaner.strategy = :deletion
#   end
#
#   config.before(:each) do
#     DatabaseCleaner.start
#   end
#
#   config.append_after(:each) do
#     DatabaseCleaner.clean
#   end
# end
