# frozen_string_literal: true

require 'vvs/base'

module VVS
  class Line < Base
    attr_accessor :stations

    def initialize(id, name)
      super
      @stations = []
    end

    def previous_station(station)
      case current = @stations.find_index(station)
      when nil
        raise "#{station} is not part of #{self}"
      when 0
        nil # we are the first station
      else
        @stations[current - 1]
      end
    end
  end
end
