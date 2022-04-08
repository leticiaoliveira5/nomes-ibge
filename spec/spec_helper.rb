require 'active_support/all'
require 'vcr_setup'
require_relative '../lib/view'
require_relative '../lib/pesquisa'

PROJECT_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(PROJECT_ROOT, 'lib', '*.rb')).each do |file|
  autoload File.basename(file, '.rb').camelize, file
end

RSpec.configure do |config|
  config.alias_example_group_to :feature, type: :feature
  config.alias_example_to :scenario
end
