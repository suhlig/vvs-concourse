# frozen_string_literal: true

require 'pry'
require 'pathname'

RSpec.configure do |config|
end

def fixture(path)
  Pathname('fixtures').join(path).expand_path(__dir__)
end
