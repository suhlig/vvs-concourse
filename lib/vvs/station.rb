# frozen_string_literal: true

require 'vvs/base'

module VVS
  class Station < Base
    attr_accessor :lines

    def initialize(id, name)
      super
      @lines = []
    end
  end
end
