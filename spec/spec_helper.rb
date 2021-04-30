# frozen_string_literal: true

require 'active_support/all'
PROJECT_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(PROJECT_ROOT, 'lib', '*.rb')).each do |file|
  autoload File.basename(file, '.rb').camelize, file
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect, :should]
  end
end
